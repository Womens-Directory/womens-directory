<template>
	<h1>Hello world!</h1>
</template>

<script setup lang="ts">
type Data = {
	// visit_count: visits.count,
	// event_count: event_count,
	// event_types: event_types,
	// views_by_id: {
	// 	location: location_views,
	// 	cat_loc: cat_loc_views,
	// 	cat: cat_views,
	// 	org: org_views,
	// 	cms_page: cms_page_views,
	// }
	visit_count: number,
	event_count: number,
	event_types: {
		[key: string]: number,
	},
	views_by_id: {
	},
}

const props = defineProps({
	data: {
		type: Object,
		required: true,
	}
})
</script>

<style scoped>
h1 {
	color: red;
}
</style>
