import Vue from "vue";
import AnalyticsReport from "../analytics_report.vue";

document.addEventListener("DOMContentLoaded", () => {
  const el = document.querySelector("#analytics-report");
  if (!el) return;
  const raw = el.attributes["data-json"].value;
  if (!raw) return;
  const data = JSON.parse(raw);
  const comp = new Vue({
    render: (h) => h(AnalyticsReport, { props: { data } }),
  }).$mount();
  el.appendChild(comp.$el);
});
