<template>
	<div>
		<!-- <div class="bar-graph" data-name="loc">
			<h2>Locations Viewed</h2>
			<Bar :data="locData" ref="refLoc" />
		</div>
		<div class="bar-graph" data-name="catLoc">
			<h2>Categories of Locations Viewed</h2>
			<Bar :data="catLocData" ref="refCatLoc" />
		</div>
		<div class="bar-graph" data-name="cat">
			<h2>Categories Viewed</h2>
			<Bar :data="catData" ref="refCat" />
		</div> -->
		<canvas id="pieChart" width="400" height="400"></canvas>
	</div>
</template>

<script setup lang="ts">


import {
	Chart as ChartJS,
	ArcElement,
	BarElement,
	CategoryScale,
	Legend,
	LinearScale,
	Title,
	Tooltip,
	PieController,
	BarController
} from 'chart.js'
import { Bar, Pie } from 'vue-chartjs'
import ColorHash from 'color-hash'
import { onMounted, ref } from 'vue'

const colorHash = new ColorHash({ saturation: 0.7 })

ChartJS.register(
	ArcElement,
	BarElement,
	CategoryScale,
	Legend,
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

// const props = defineProps<{ data: Data }>()
// const viewsByID = props.data.views_by_id

// const locData = {
// 	labels: [], datasets: [{ data: [], backgroundColor: [] }]
// }
// Object.values(viewsByID.location).sort((a, b) => b.count - a.count).slice(0, 50).forEach((loc) => {
// 	locData.labels.push(loc.name)
// 	locData.datasets[0].data.push(loc.count)
// 	locData.datasets[0].backgroundColor.push(colorHash.hex(loc.name))
// })

// const catLocData = {
// 	labels: [], datasets: [{ data: [], backgroundColor: [] }]
// }
// Object.values(viewsByID.cat_loc).sort((a, b) => b.count - a.count).forEach((cat) => {
// 	catLocData.labels.push(cat.name)
// 	catLocData.datasets[0].data.push(cat.count)
// 	catLocData.datasets[0].backgroundColor.push(colorHash.hex(cat.name))
// })

// const catData = {
// 	labels: [], datasets: [{ data: [], backgroundColor: [] }]
// }
// Object.values(viewsByID.cat).sort((a, b) => b.count - a.count).forEach((cat) => {
// 	catData.labels.push(cat.name)
// 	catData.datasets[0].data.push(cat.count)
// 	catData.datasets[0].backgroundColor.push(colorHash.hex(cat.name))
// })

// const dataSets = {
// 	loc: locData,
// 	catLoc: catLocData,
// 	cat: catData,
// }

// const refLoc = ref(null)
// const refCatLoc = ref(null)
// const refCat = ref(null)


onMounted(() => {
	setTimeout(() => {
		const canvasP = document.querySelector('#pieChart');
		const ctxP = canvasP.getContext('2d');
		const myPieChart = new ChartJS(ctxP, {
			type: 'pie',
			data: {
				labels: ["Värde 1", "Värde 2", "Värde 3", "Värde 4", "Värde 5", "Värde 6", "Värde 7"],
				datasets: [{
					data: [1, 5, 10, 20, 50, 70, 50],
					backgroundColor: ["#64B5F6", "#FFD54F", "#2196F3", "#FFC107", "#1976D2", "#FFA000", "#0D47A1"],
					hoverBackgroundColor: ["#B2EBF2", "#FFCCBC", "#4DD0E1", "#FF8A65", "#00BCD4", "#FF5722", "#0097A7"]
				}]
			},
		});

		canvasP.onclick = function (e) {
			var slice = myPieChart.getElementsAtEventForMode(e, 'nearest', { intersect: true }, true);
			if (!slice.length) return;
			var label = myPieChart.data.labels[slice[0].index];
			console.log({ label })
		}
	}, 0)

	// console.log({ refLoc, refCatLoc, refCat })
	// function instrument() {
	// 	const elems = document.querySelectorAll('.bar-graph')

	// 	if (elems.length === 0) {
	// 		setTimeout(instrument, 100)
	// 		return
	// 	}

	// 	elems.forEach((el) => {
	// 		const name = el.attributes['data-name'].value
	// 		const canvas = el.querySelector('canvas')
	// 		canvas.onclick = e => {
	// 			const dataSet = dataSets[name]
	// 			const container = ref(name)
	// 			const chart = container
	// 			console.log(chart)
	// 		}
	// 	})
	// }
	// instrument()
})
</script>

<style scoped>
h1 {
	color: red;
}

.pie {
	max-width: 400px;
}
</style>
