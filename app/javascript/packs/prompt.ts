import Vue from "vue";
import Prompt from "../prompt.vue";

document.addEventListener("DOMContentLoaded", () => {
  const prompt = userPrompt.prompt()
  const promptIsOn = userPrompt.promptOn()
  
  if (promptIsOn) {
    userPrompt.setPromptPageVisit()
  }

  const props = {
    link: prompt.get('link'),
    text: prompt.get('text'),
    promptOn: promptIsOn,
  }

  const comp = new Vue({
    render: h => h(Prompt, { props })
  }).$mount();
  document.body.appendChild(comp.$el);
});

const userPrompt = (() => {
  const hasVisited = getCookie() !== null;
  const cookieName = 'wd_visitedLocationShowPage';

  const getPrompt = () => {
    let promptMap = new Map();
    let prompt = document.querySelector('.prompt-external-link');
  
    promptMap.set('link', prompt ? prompt.attributes['data-link'].value : "");
    promptMap.set('text', prompt ? prompt.attributes['data-text'].value : "");
  
    return promptMap
  }

  const promptOn = () => {
    let prompt = getPrompt()
    let linkEmpty = prompt.get('link') === ""
    let textEmpty = prompt.get('text') === ""

    return !hasVisited && !linkEmpty && !textEmpty
  }

  const setCookie = () => {
    if (!hasVisited) {
      let date = Date.now().toString()
      localStorage.setItem(cookieName, date)
    }
  }
  
  function getCookie() {
    return localStorage.getItem(cookieName);
  }

  return {
    setPromptPageVisit: () => setCookie(),
    prompt: () => getPrompt(),
    promptOn: () => promptOn(),
  }
})();
