import Vue from "vue";
import Feedback from "../feedback.vue";

document.addEventListener("DOMContentLoaded", () => {
  const props = {
    currentPath: document.querySelector("#current-path").textContent,
    csrfToken: document
      .querySelector('meta[name="csrf-token"]')
      .getAttribute("content")
  };

  const comp = new Vue({
    render: h => h(Feedback, { props })
  }).$mount("#feedback");
});
