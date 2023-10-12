<template>
<div id="modal" class="modal" :class="{'is-active': isActive}">
  <div class="modal-background"></div>
  
  <div class="modal-content modal-content-with-frame">
    <div class="frame"></div>
    <!-- Preliminary Form -->
    <div class="box framed">
      <div v-if="formName == 'consent'" class="block">
        <article class="media">
          <div class="media-content">
            <div class="content prompt-external-link-display has-text-weight-semibold">
              <!-- Prompts pulled from prompt-external-link html classes -->
              <p>{{ prompt.get('text') }}</p>
            </div>
          </div>
        </article>
      </div>
      <div class="buttons block">
        <a :href="`${prompt.get('link')}`" target="_blank" class="button">Yes</a>
        <button class="button" @click="hidePrompt">Not Now</button>
      </div>
    </div>
  </div>

</div>
</template>

<script lang="ts">
export default {
  props: {
    prompt: { type: Map, required: false }
  },
  data() {
    return {
      formName: 'consent',
      // Set on a timer initially false
      isActive: false,
    }
  },
  methods: {
    nextStep() {
      this.formName = 'questionnaire';
    },
    hidePrompt() {
      this.isActive = false
    }
  },
  mounted() {
    setTimeout(() => { 
      if (this.prompt.size > 0) 
        this.isActive = true 
    }, 4000);
  }
}
</script>

<style lang="scss">
  .modal-content.modal-content-with-frame .framed{
    filter: drop-shadow(0 0 0.75rem rgba(52, 66, 70, 0.374));
    z-index: 42;
    margin: 35px 40px;
    padding: 60px 50px 30px;
    position: relative;
  }
  .frame {
    position: absolute;
    border-radius: 19px;
    background-color: #BAB5FA;
    height: 77%;
    width: 89%;
    z-index: 41;
  }
</style>