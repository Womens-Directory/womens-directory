import Vue from "vue";
import Feedback from "../feedback.vue";

document.addEventListener("DOMContentLoaded", () => {
  const props = {
    currentPath: document.querySelector("#current-path").textContent
  };

  const comp = new Vue({
    render: h => h(Feedback, { props })
  }).$mount();
  document.body.appendChild(comp.$el);
});
