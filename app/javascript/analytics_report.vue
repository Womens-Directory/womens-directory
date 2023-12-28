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
	</div>
</template>

<script setup lang="ts">
import { Chart as ChartJS, ArcElement, Tooltip, Legend } from 'chart.js'
import { defineComponent } from 'vue'
import { Pie } from 'vue-chartjs'

ChartJS.register(ArcElement, Tooltip, Legend)

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
	labels: [], datasets: [{ data: [] }]
}
Object.values(viewsByID.cat_loc).sort((a, b) => b.count - a.count).forEach((cat) => {
	catLocData.labels.push(cat.name)
	catLocData.datasets[0].data.push(cat.count)
})

const catData = {
	labels: [], datasets: [{ data: [] }]
}
Object.values(viewsByID.cat).sort((a, b) => b.count - a.count).forEach((cat) => {
	catData.labels.push(cat.name)
	catData.datasets[0].data.push(cat.count)
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
