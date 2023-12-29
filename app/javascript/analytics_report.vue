<template>
	<div>
		<div class="tabs is-boxed">
			<ul>
				<li v-for="{ id, name } in tabs" :key="id"
					:class="{ 'is-active': currentTab === id, 'has-text-weight-bold': true, 'mt-4': true }">
					<a @click="selectTab(id)">{{ name }}</a>
				</li>
			</ul>
		</div>

		<div data-graph-aggregate="summary" :class="{ 'is-hidden': currentTab !== 'summary' }">
			<h1>Summary</h1>

			<div class="columns">
				<div class="column is-half">
					<h2>Statistics</h2>
					<ul>
						<li v-for="[k, v] of Object.entries(stats)" :key="k">
							<strong>{{ k }}:</strong> {{ v }}
						</li>
					</ul>
				</div>

				<div class="column is-half">
					<h2>Aggregate Views by Site Area</h2>
					<canvas data-graph-content="event-types"></canvas>
				</div>
			</div>

			<h2>Visits by Date</h2>
			<label for="visits-by-date-smooth">Smoothing:</label>
			<select name="visits-by-date-smooth" @change="updateVisitSmoothing">
				<option value="0">No smoothing</option>
				<option value="1">3-day window</option>
				<option value="3">7-day window</option>
				<option value="7">15-day window</option>
				<option value="15">31-day window</option>
			</select>
			<canvas data-graph-content="visits-by-date"></canvas>
		</div>

		<div v-for="{ id, name, desc } in aggrTabs" :key="id" :data-graph-aggregate="id"
			:class="{ 'is-hidden': currentTab !== id }">
			<h1>{{ name }}</h1>
			<p>{{ desc }}</p>
			<h2>Location Views</h2>
			<p>The number of views for a given location in the reporting period.</p>
			<canvas data-graph-content="loc"></canvas>
			<h2>Category Views</h2>
			<p>The number of views for a given category in the reporting period.</p>
			<canvas data-graph-content="cat"></canvas>
			<h2>Categories of Location Views</h2>
			<p>This is an aggregate of <em>all</em> categories listed for each location that is viewed by a visitor. For
				example, if a visitor views <em>Acme Assistance</em>, and this location is listed under both
				<em>Mental Health</em> and <em>Food Assistance</em> categories, both
				<em>Mental Health</em> and <em>Food Assistance</em> will have one view.
			</p> <canvas data-graph-content="cat-loc"></canvas>
			<h2>Organization Views</h2>
			<p>The number of views for an organization in the reporting period.</p>
			<canvas data-graph-content="org"></canvas>
			<h2>Page Views</h2>
			<p>The number of views for a page in the site CMS in the reporting period.</p>
			<canvas data-graph-content="page"></canvas>
		</div>
	</div>
</template>

<script setup lang="ts">
import {
	Chart as ChartJS,
	ArcElement,
	BarController,
	BarElement,
	CategoryScale,
	ChartType,
	Legend,
	LinearScale,
	LineController,
	LineElement,
	PieController,
	PointElement,
	Title,
	Tooltip,
} from 'chart.js'
import ColorHash from 'color-hash'
import { onMounted, ref } from 'vue'

const colorHash = new ColorHash({ saturation: 0.7 })

ChartJS.register(
	ArcElement,
	BarController,
	BarElement,
	CategoryScale,
	Legend,
	LinearScale,
	LineController,
	LineElement,
	PieController,
	PointElement,
	Title,
	Tooltip,
)

type LocationSummary = {
	count: number,
	id: number,
	name: string,
	desc: string,
	link: string,
	where: string,
}

type CategorySummary = {
	count: number,
	id: number,
	name: string,
	desc: string,
	link: string,
}

type OrgSummary = {
	count: number,
	id: number,
	name: string,
	desc: string,
	link: string,
	website: string,
}

type CmsPageSummary = {
	count: number,
	id: number,
	name: string,
	link: string,
}

interface Graphable {
	name: string,
	count: number,
	link?: string,
}

type ViewData = {
	location: { [key: string]: LocationSummary },
	cat_loc: { [key: string]: CategorySummary },
	cat: { [key: string]: CategorySummary },
	org: { [key: string]: OrgSummary },
	cms_page: { [key: string]: CmsPageSummary },
}

type Data = {
	visit_count: number,
	visit_count_by_date: { [key: string]: number },
	event_count: number,
	event_types: { [key: string]: number },
	total_views: ViewData,
	views_by_visit: ViewData,
	views_by_visitor: ViewData,
}

type SortBy = 'DONT_SORT' | {
	type: 'name' | 'count',
	direction: 'asc' | 'desc',
}

const props = defineProps<{ data: Data }>()
const viewsByID = props.data.total_views
const viewsByVisit = props.data.views_by_visit
const viewsByVisitor = props.data.views_by_visitor

const totalViews = { location: 0, cat: 0, org: 0, cms_page: 0 };
['location', 'cat', 'org', 'cms_page'].map((key) => {
	totalViews[key] = Object.values(viewsByID[key]).reduce((acc: number, cur: Graphable) => acc + cur.count, 0)
})

function render(elem: HTMLCanvasElement, type: ChartType, data: Graphable[], maxCount?: number, sortBy?: SortBy) {
	if (!maxCount && type === 'bar') maxCount = 30
	let items = data;

	if (!sortBy) sortBy = { type: 'count', direction: 'desc' }
	if (sortBy !== 'DONT_SORT') {
		const { type, direction } = sortBy
		if (type === 'count') {
			items = items.sort((a, b) => direction === 'asc' ? a.count - b.count : b.count - a.count)
		} else {
			items = items.sort((a, b) => direction === 'asc' ? a.name.localeCompare(b.name) : b.name.localeCompare(a.name))
		}
	}

	if (maxCount) items = items.slice(0, maxCount)
	const labels = items.map(({ name }) => name);
	const values = items.map(({ count }) => count);
	const backgroundColor = items.map(({ name }) => colorHash.hex(name));

	const context = elem.getContext('2d');
	const chart = new ChartJS(context, {
		type,
		data: { labels, datasets: [{ data: values, backgroundColor }] },
		options: { plugins: { legend: { display: type === 'pie' } } }
	});

	elem.onclick = function (e) {
		var slice = chart.getElementsAtEventForMode(e, 'nearest', { intersect: true }, true);
		if (!slice.length) return;
		const item = items[slice[0].index];
		if (!item.link) return;
		window.open(item.link, '_blank');
	};

	return chart;
}

const visitsByDate = Object.entries(props.data.visit_count_by_date)
	.map(([name, count]) => ({ name: `Daily visits: ${name}`, count }))
	.sort((a, b) => a.name.localeCompare(b.name))

function dateToMmDd(date: Date) {
	return `${date.getMonth() + 1}/${date.getDate()}`
}

const windowSize = ref(0)
let visitsByDateChart: ChartJS;
const visitsByDateChartSelector = '[data-graph-content="visits-by-date"]'

function renderVisits() {
	if (visitsByDateChart) visitsByDateChart.destroy();

	if (windowSize.value === 0) {
		visitsByDateChart = render(
			document.querySelector(visitsByDateChartSelector),
			'line', visitsByDate, undefined, 'DONT_SORT',
		)
		return;
	}

	const visitsByDateSmooth = visitsByDate.map(({ }, i) => {
		const start = Math.max(0, i - windowSize.value - 1);
		const end = Math.min(visitsByDate.length, i + windowSize.value);
		const window = visitsByDate.slice(start, end);
		const sum = window.reduce((sum, { count }) => sum + count, 0);

		const firstDateInRange = new Date(window[0].name);
		const lastDateInRange = new Date(window[window.length - 1].name);
		const nameRange = `Avg daily visits: ${dateToMmDd(firstDateInRange)} - ${dateToMmDd(lastDateInRange)}`;

		return { name: nameRange, count: Math.floor(sum / window.length) };
	})

	visitsByDateChart = render(
		document.querySelector(visitsByDateChartSelector),
		'line', visitsByDateSmooth, undefined, 'DONT_SORT',
	)
}

function updateVisitSmoothing(ev: Event) {
	windowSize.value = parseInt((ev.target as HTMLSelectElement).value, 10);
	renderVisits();
}

const aggrTabs = [
	{ id: 'total-views', name: 'Total Views', desc: 'All page views are counted individually, even if the same visitor views a page multiple times during a single visit.' },
	{ id: 'by-visit', name: 'By Visit', desc: 'Pages viewed multiple times during a single visit are counted once. Pages viewed on two separate visits are counted twice.' },
	{ id: 'by-visitor', name: 'By Visitor', desc: 'Pages viewed multiple times by the same visitor are only counted once, even if they are on separate visits.' },
]

const tabs = [
	{ id: 'summary', name: 'Summary' },
	...aggrTabs
]

const dataSets: Record<string, { type: ChartType, data: Graphable[], maxCount?: number, sortBy?: SortBy }> = {
	'[data-graph-content="event-types"]': { type: 'pie', data: Object.entries(props.data.event_types).map(([name, count]) => ({ name, count })) },

	'div[data-graph-aggregate="total-views"] canvas[data-graph-content="loc"]': { type: 'bar', data: Object.values(viewsByID.location) },
	'div[data-graph-aggregate="total-views"] canvas[data-graph-content="cat-loc"]': { type: 'bar', data: Object.values(viewsByID.cat_loc) },
	'div[data-graph-aggregate="total-views"] canvas[data-graph-content="cat"]': { type: 'bar', data: Object.values(viewsByID.cat) },
	'div[data-graph-aggregate="total-views"] canvas[data-graph-content="org"]': { type: 'bar', data: Object.values(viewsByID.org) },
	'div[data-graph-aggregate="total-views"] canvas[data-graph-content="page"]': { type: 'bar', data: Object.values(viewsByID.cms_page) },

	'div[data-graph-aggregate="by-visit"] canvas[data-graph-content="loc"]': { type: 'bar', data: Object.values(viewsByVisit.location) },
	'div[data-graph-aggregate="by-visit"] canvas[data-graph-content="cat-loc"]': { type: 'bar', data: Object.values(viewsByVisit.cat_loc) },
	'div[data-graph-aggregate="by-visit"] canvas[data-graph-content="cat"]': { type: 'bar', data: Object.values(viewsByVisit.cat) },
	'div[data-graph-aggregate="by-visit"] canvas[data-graph-content="org"]': { type: 'bar', data: Object.values(viewsByVisit.org) },
	'div[data-graph-aggregate="by-visit"] canvas[data-graph-content="page"]': { type: 'bar', data: Object.values(viewsByVisit.cms_page) },

	'div[data-graph-aggregate="by-visitor"] canvas[data-graph-content="loc"]': { type: 'bar', data: Object.values(viewsByVisitor.location) },
	'div[data-graph-aggregate="by-visitor"] canvas[data-graph-content="cat-loc"]': { type: 'bar', data: Object.values(viewsByVisitor.cat_loc) },
	'div[data-graph-aggregate="by-visitor"] canvas[data-graph-content="cat"]': { type: 'bar', data: Object.values(viewsByVisitor.cat) },
	'div[data-graph-aggregate="by-visitor"] canvas[data-graph-content="org"]': { type: 'bar', data: Object.values(viewsByVisitor.org) },
	'div[data-graph-aggregate="by-visitor"] canvas[data-graph-content="page"]': { type: 'bar', data: Object.values(viewsByVisitor.cms_page) },
}

const visitCount = props.data.visit_count
const stats = {
	'Total Visits': visitCount,
	'Avg Locations Viewed/Visit': (totalViews.location / visitCount).toFixed(1),
	'Avg Categories Viewed/Visit': (totalViews.cat / visitCount).toFixed(1),
	'Avg Orgs Viewed/Visit': (totalViews.org / visitCount).toFixed(1),
	'Avg Pages Viewed/Visit': (totalViews.cms_page / visitCount).toFixed(1),
}

onMounted(() => {
	setTimeout(() => {
		Object.entries(dataSets).forEach(([selector, { type, data, maxCount, sortBy }]) => {
			console.log({ selector })
			render(document.querySelector(selector), type, data, maxCount, sortBy)
		})
		renderVisits()
	}, 0)
})

const currentTab = ref('summary')

function selectTab(name: string) {
	currentTab.value = name
}
</script>
