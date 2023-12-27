<template>
	<h1>Hello world!</h1>
</template>

<script setup lang="ts">
type LocationSummary = {
	id: number,
	name: string,
	desc: string,
	link: string,
	where: string,
}

type CategorySummary = {
	id: number,
	name: string,
	desc: string,
	link: string,
}

type OrgSummary = {
	id: number,
	name: string,
	desc: string,
	link: string,
	website: string,
}

type CmsPageSummary = {
	id: number,
	name: string,
	link: string,
}

type Data = {
	data: {
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
}

const props = defineProps<Data>()
</script>

<style scoped>
h1 {
	color: red;
}
</style>
