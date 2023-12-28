<template>
	<div>
		<div class="pie">
			<h2>Categories of Locations Viewed</h2>
			<Pie :data="catLocData" />
		</div>
		<div class="pie">
			<h2>Categories Viewed</h2>
			<Pie :data="catData" />
		</div>
		<div class="bar">
			<h2>Categories of Locations Viewed</h2>
			<Bar :data="catLocData" />
		</div>
		<div class="bar">
			<h2>Categories Viewed</h2>
			<Bar :data="catData" />
		</div>
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
} from 'chart.js'
import { Bar, Pie } from 'vue-chartjs'
import ColorHash from 'color-hash'

const colorHash = new ColorHash({ saturation: 0.7 })

ChartJS.register(
	ArcElement,
	BarElement,
	CategoryScale,
	Legend,
	LinearScale,
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

// const categoryData = {
// 	labels: ['VueJs', 'EmberJs', 'ReactJs', 'AngularJs'],
// 	datasets: [
// 		{
// 			backgroundColor: ['#41B883', '#E46651', '#00D8FF', '#DD1B16'],
// 			data: [40, 20, 80, 10]
// 		}
// 	]
// }

const viewsByID = props.data.views_by_id

const catLocData = {
	labels: [], datasets: [{ data: [], backgroundColor: [] }]
}
Object.values(viewsByID.cat_loc).sort((a, b) => b.count - a.count).forEach((cat) => {
	catLocData.labels.push(cat.name)
	catLocData.datasets[0].data.push(cat.count)
	catLocData.datasets[0].backgroundColor.push(colorHash.hex(cat.name))
})

const catData = {
	labels: [], datasets: [{ data: [], backgroundColor: [] }]
}
Object.values(viewsByID.cat).sort((a, b) => b.count - a.count).forEach((cat) => {
	catData.labels.push(cat.name)
	catData.datasets[0].data.push(cat.count)
	catData.datasets[0].backgroundColor.push(colorHash.hex(cat.name))
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
