import Vue from "vue";
import Feedback from "../feedback.vue";

document.addEventListener("DOMContentLoaded", () => {
  const comp = new Vue({
    render: h => h(Feedback)
  }).$mount();
  document.body.appendChild(comp.$el);
});
