import Vue from "vue";
import Prompt from "../prompt.vue";

document.addEventListener("DOMContentLoaded", () => {
  const props = {
    prompt: getPrompt()
  }

  const comp = new Vue({
    render: h => h(Prompt, { props })
  }).$mount();
  document.body.appendChild(comp.$el);
});

function getPrompt() {
  let prompts = document.querySelectorAll('.prompt-external-link');
  let promptHash = new Map();

  prompts.forEach((p) => {
    promptHash.set('link', p.attributes['data-link'].value);
    promptHash.set('text', p.attributes['data-text'].value);
  })

  return promptHash
}