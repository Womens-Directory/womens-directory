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
			<h2>Aggregate Views by Site Area</h2>
			<div class="small" style="max-width: 400px;">
				<canvas data-graph-content="event-types"></canvas>
			</div>
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
	BarElement,
	CategoryScale,
	LinearScale,
	Title,
	Tooltip,
	PieController,
	BarController,
	ChartType,
	Legend
} from 'chart.js'
import ColorHash from 'color-hash'
import { onMounted, ref } from 'vue'

const colorHash = new ColorHash({ saturation: 0.7 })

ChartJS.register(
	ArcElement,
	BarElement,
	CategoryScale,
	LinearScale,
	Title,
	Tooltip,
	Legend,
	BarController,
	PieController
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
	event_count: number,
	event_types: { [key: string]: number },
	total_views: ViewData,
	views_by_visit: ViewData,
	views_by_visitor: ViewData,
}

const props = defineProps<{ data: Data }>()
const viewsByID = props.data.total_views
const viewsByVisit = props.data.views_by_visit
const viewsByVisitor = props.data.views_by_visitor

function render(elem: HTMLCanvasElement, type: ChartType, data: Graphable[], maxCount?: number) {
	if (!maxCount && type === 'bar') maxCount = 30
	// Sort data by descending count
	let items = data.sort((a, b) => b.count - a.count)
	if (maxCount) items = items.slice(0, maxCount)
	const labels = items.map(({ name }) => name);
	const values = items.map(({ count }) => count);
	const backgroundColor = items.map(({ name }) => colorHash.hex(name));

	const context = elem.getContext('2d');
	const chart = new ChartJS(context, {
		type,
		data: { labels, datasets: [{ data: values, backgroundColor }] },
		options: { plugins: { legend: { display: type !== 'bar' } } }
	});

	elem.onclick = function (e) {
		var slice = chart.getElementsAtEventForMode(e, 'nearest', { intersect: true }, true);
		if (!slice.length) return;
		const item = items[slice[0].index];
		if (!item.link) return;
		window.open(item.link, '_blank');
	};
}

const dataSets: Record<string, { type: ChartType, data: Graphable[], maxCount?: number }> = {
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
		Object.entries(dataSets).forEach(([selector, { type, data, maxCount }]) => {
			render(document.querySelector(selector), type, data, maxCount)
		})
	}, 0)
})

const currentTab = ref('summary')

function selectTab(name: string) {
	currentTab.value = name
}
</script>

<style scoped>
.small {
	max-width: 400px;
}
</style>
