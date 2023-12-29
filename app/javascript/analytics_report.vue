<template>
	<div>
		<div class="tabs is-boxed">
			<ul>
				<li :class="{ 'is-active': currentTab === 'summary' }"><a @click="selectTab('summary')">Summary</a>
				</li>
				<li :class="{ 'is-active': currentTab === 'total-views' }"><a @click="selectTab('total-views')">Total Views</a>
				</li>
				<li :class="{ 'is-active': currentTab === 'by-visit' }"><a @click="selectTab('by-visit')">By Visit</a></li>
				<li :class="{ 'is-active': currentTab === 'by-visitor' }"><a @click="selectTab('by-visitor')">By Visitor</a></li>
			</ul>
		</div>

		<div data-graph-aggregate="summary" :class="{ 'is-hidden': currentTab !== 'summary' }">
			<h1>Summary</h1>

			<div class="columns">
				<div class="column is-half">
					<h2>Statistics</h2>
					<ul>
						<li>
							<strong>Total Visits:</strong>
							{{ data.visit_count }}
						</li>
						<li>
							<strong>Avg Locations Viewed/Visit:</strong>
							{{ (totalViews.location / data.visit_count).toFixed(1) }}
						</li>
						<li>
							<strong>Avg Categories Viewed/Visit:</strong>
							{{ (totalViews.cat / data.visit_count).toFixed(1) }}
						</li>
						<li>
							<strong>Avg Orgs Viewed/Visit:</strong>
							{{ (totalViews.org / data.visit_count).toFixed(1) }}
						</li>
						<li>
							<strong>Avg Pages Viewed/Visit:</strong>
							{{ (totalViews.cms_page / data.visit_count).toFixed(1) }}
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

		<div data-graph-aggregate="total-views" :class="{ 'is-hidden': currentTab !== 'total-views' }">
			<h1>Total Views</h1>
			<p>All page views are counted individually, even if the same visitor views a page multiple times during a single
				visit.</p>
			<h2>Locations Viewed</h2>
			<canvas data-graph-content="loc"></canvas>
			<h2>Categories of Locations Viewed</h2>
			<canvas data-graph-content="cat-loc"></canvas>
			<h2>Categories Viewed</h2>
			<canvas data-graph-content="cat"></canvas>
			<h2>Organizations Viewed</h2>
			<canvas data-graph-content="org"></canvas>
			<h2>Pages Viewed</h2>
			<canvas data-graph-content="page"></canvas>
		</div>

		<div data-graph-aggregate="by-visit" :class="{ 'is-hidden': currentTab !== 'by-visit' }">
			<h1>By Visit</h1>
			<p>Pages viewed multiple times during a single visit are counted once. Pages viewed on two separate visits are
				counted twice.</p>
			<h2>Locations Viewed</h2>
			<canvas data-graph-content="loc"></canvas>
			<h2>Categories of Locations Viewed</h2>
			<canvas data-graph-content="cat-loc"></canvas>
			<h2>Categories Viewed</h2>
			<canvas data-graph-content="cat"></canvas>
			<h2>Organizations Viewed</h2>
			<canvas data-graph-content="org"></canvas>
			<h2>Pages Viewed</h2>
			<canvas data-graph-content="page"></canvas>
		</div>

		<div data-graph-aggregate="by-visitor" :class="{ 'is-hidden': currentTab !== 'by-visitor' }">
			<h1>By Visitor</h1>
			<p>Pages viewed multiple times by the same visitor are only counted once, even if they are on separate visits.</p>
			<h2>Locations Viewed</h2>
			<canvas data-graph-content="loc"></canvas>
			<h2>Categories of Locations Viewed</h2>
			<canvas data-graph-content="cat-loc"></canvas>
			<h2>Categories Viewed</h2>
			<canvas data-graph-content="cat"></canvas>
			<h2>Organizations Viewed</h2>
			<canvas data-graph-content="org"></canvas>
			<h2>Pages Viewed</h2>
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

onMounted(() => {
	setTimeout(() => {
		Object.entries(dataSets).forEach(([selector, { type, data, maxCount, sortBy }]) => {
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
