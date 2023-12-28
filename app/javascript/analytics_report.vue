<template>
	<div>
		<div class="tabs is-boxed">
			<ul>
				<li :class="{ 'is-active': currentTab === 'total-views' }"><a @click="selectTab('total-views')">Total Views</a>
				</li>
				<li :class="{ 'is-active': currentTab === 'by-visit' }"><a @click="selectTab('by-visit')">By Visit</a></li>
				<li :class="{ 'is-active': currentTab === 'by-visitor' }"><a @click="selectTab('by-visitor')">By Visitor</a></li>
			</ul>
		</div>

		<div data-graph-aggregate="total-views" :class="{ 'is-hidden': currentTab !== 'total-views' }">
			<h1>Total Views</h1>
			<p>Counting all page views, even multiple views of the same page by the same visitor during the same visit.</p>
			<div>
				<h2>Locations Viewed</h2>
				<canvas data-graph-content="loc"></canvas>
			</div>
			<div>
				<h2>Categories of Locations Viewed</h2>
				<canvas data-graph-content="cat-loc"></canvas>
			</div>
			<div>
				<h2>Categories Viewed</h2>
				<canvas data-graph-content="cat"></canvas>
			</div>
		</div>

		<div data-graph-aggregate="by-visit" :class="{ 'is-hidden': currentTab !== 'by-visit' }">
			<h1>By Visit</h1>
			<p>Pages viewed multiple times during a single visit are counted once. Views on separate visits are counted multiple
				times.</p>
			<div>
				<h2>Locations Viewed</h2>
				<canvas data-graph-content="loc"></canvas>
			</div>
			<div>
				<h2>Categories of Locations Viewed</h2>
				<canvas data-graph-content="cat-loc"></canvas>
			</div>
			<div>
				<h2>Categories Viewed</h2>
				<canvas data-graph-content="cat"></canvas>
			</div>
		</div>

		<div data-graph-aggregate="by-visitor" :class="{ 'is-hidden': currentTab !== 'by-visitor' }">
			<h1>By Visitor</h1>
			<p>Pages viewed multiple times by the same visitor are only counted once, even if they are on separate visits.</p>
			<div>
				<h2>Locations Viewed</h2>
				<canvas data-graph-content="loc"></canvas>
			</div>
			<div>
				<h2>Categories of Locations Viewed</h2>
				<canvas data-graph-content="cat-loc"></canvas>
			</div>
			<div>
				<h2>Categories Viewed</h2>
				<canvas data-graph-content="cat"></canvas>
			</div>
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
	BarController
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
	link: string,
	count: number,
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

function render(elem: HTMLCanvasElement, data: Graphable[], maxCount?: number) {
	// Sort data by descending count
	let items = data.sort((a, b) => b.count - a.count)
	if (maxCount) items = items.slice(0, maxCount)
	const labels = items.map(({ name }) => name);
	const values = items.map(({ count }) => count);
	const backgroundColor = items.map(({ name }) => colorHash.hex(name));

	const context = elem.getContext('2d');
	const chart = new ChartJS(context, {
		type: 'bar', data: { labels, datasets: [{ data: values, backgroundColor }] },
	});

	elem.onclick = function (e) {
		var slice = chart.getElementsAtEventForMode(e, 'nearest', { intersect: true }, true);
		if (!slice.length) return;
		const item = items[slice[0].index];
		window.open(item.link, '_blank');
	};
}

const dataSets: Record<string, { data: Graphable[], maxCount?: number }> = {
	'div[data-graph-aggregate="total-views"] canvas[data-graph-content="loc"]': { data: Object.values(viewsByID.location), maxCount: 20 },
	'div[data-graph-aggregate="total-views"] canvas[data-graph-content="cat-loc"]': { data: Object.values(viewsByID.cat_loc) },
	'div[data-graph-aggregate="total-views"] canvas[data-graph-content="cat"]': { data: Object.values(viewsByID.cat) },
	'div[data-graph-aggregate="by-visit"] canvas[data-graph-content="loc"]': { data: Object.values(props.data.views_by_visit.location), maxCount: 20 },
	'div[data-graph-aggregate="by-visit"] canvas[data-graph-content="cat-loc"]': { data: Object.values(props.data.views_by_visit.cat_loc) },
	'div[data-graph-aggregate="by-visit"] canvas[data-graph-content="cat"]': { data: Object.values(props.data.views_by_visit.cat) },
	'div[data-graph-aggregate="by-visitor"] canvas[data-graph-content="loc"]': { data: Object.values(props.data.views_by_visitor.location), maxCount: 20 },
	'div[data-graph-aggregate="by-visitor"] canvas[data-graph-content="cat-loc"]': { data: Object.values(props.data.views_by_visitor.cat_loc) },
	'div[data-graph-aggregate="by-visitor"] canvas[data-graph-content="cat"]': { data: Object.values(props.data.views_by_visitor.cat) },
}

onMounted(() => {
	setTimeout(() => {
		Object.entries(dataSets).forEach(([selector, dataSet]) => {
			render(document.querySelector(selector), dataSet.data, dataSet.maxCount)
		})
	}, 0)
})

const currentTab = ref('total-views')

function selectTab(name: string) {
	currentTab.value = name
}
</script>
