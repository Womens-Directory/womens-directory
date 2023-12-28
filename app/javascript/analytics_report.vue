<template>
	<div>
		<div>
			<h2>Locations Viewed</h2>
			<canvas id="graph-loc"></canvas>
		</div>
		<div>
			<h2>Categories of Locations Viewed</h2>
			<canvas id="graph-cat-loc"></canvas>
		</div>
		<div>
			<h2>Categories Viewed</h2>
			<canvas id="graph-cat"></canvas>
		</div>
		<canvas id="chart"></canvas>
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
import { onMounted } from 'vue'

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

type Data = {
	visit_count: number,
	event_count: number,
	event_types: { [key: string]: number },
	views_by_id: {
		location: { [key: string]: LocationSummary },
		cat_loc: { [key: string]: CategorySummary },
		cat: { [key: string]: CategorySummary },
		org: { [key: string]: OrgSummary },
		cms_page: { [key: string]: CmsPageSummary },
	},
}

const props = defineProps<{ data: Data }>()
const viewsByID = props.data.views_by_id

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
	'#graph-loc': { data: Object.values(viewsByID.location), maxCount: 20 },
	'#graph-cat-loc': { data: Object.values(viewsByID.cat_loc) },
	'#graph-cat': { data: Object.values(viewsByID.cat) },
}

onMounted(() => {
	setTimeout(() => {
		Object.entries(dataSets).forEach(([selector, dataSet]) => {
			render(document.querySelector(selector), dataSet.data, dataSet.maxCount)
		})
	}, 0)
})
</script>
