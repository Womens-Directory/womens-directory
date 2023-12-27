import Vue from "vue";
import AnalyticsReport from "../analytics_report.vue";

document.addEventListener("DOMContentLoaded", () => {
  const el = document.querySelector("#analytics-report");
  console.log({ el });
  if (!el) return;
  const comp = new Vue({
    render: (h) => h(AnalyticsReport),
  }).$mount();
  el.appendChild(comp.$el);
});
