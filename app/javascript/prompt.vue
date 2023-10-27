<template>
  <div id="modal" class="modal" :class="{ 'is-active': isActive }">
    <div class="modal-background"></div>

    <div class="modal-content modal-content-with-frame">
      <div class="frame"></div>
      <!-- Preliminary Form -->
      <div class="box framed">
        <div class="block">
          <article class="media">
            <div class="media-content">
              <div
                class="content prompt-external-link-display has-text-weight-semibold"
              >
                <!-- Prompts pulled from prompt-external-link html classes -->
                <p>{{ text }}</p>
              </div>
            </div>
          </article>
        </div>
        <div class="buttons block">
          <a
            :href="`${link}`"
            target="_blank"
            class="button"
            @click="hidePrompt"
            >Yes</a
          >
          <button class="button" @click="hidePrompt">Not Now</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
export default {
  props: {
    link: { type: String, required: true },
    text: { type: String, required: true },
    promptOn: { type: Boolean, required: false, default: false },
  },
  data() {
    return {
      isActive: false,
    };
  },
  methods: {
    hidePrompt() {
      this.isActive = false;
    },
  },
  mounted() {
    let waitBeforeShowMs = 300;

    setTimeout(() => {
      if (this.promptOn && this.link && this.text) {
        this.isActive = true;
      }
    }, waitBeforeShowMs);
  },
};
</script>

<style lang="scss">
.modal-content.modal-content-with-frame .framed {
  filter: drop-shadow(0 0 0.75rem rgba(52, 66, 70, 0.374));
  z-index: 42;
  margin: 35px 40px;
  padding: 60px 50px 30px;
  position: relative;
}
.frame {
  position: absolute;
  border-radius: 19px;
  background-color: #bab5fa;
  height: 77%;
  width: 89%;
  z-index: 41;
}
@keyframes fadeIn {
  0% {
    opacity: 0;
  }
  100% {
    opacity: 1;
  }
}
.modal.is-active {
  animation: fadeIn 0.5s;
  -webkit-animation: fadeIn 0.5s;
  -moz-animation: fadeIn 0.5s;
  -o-animation: fadeIn 0.5s;
  -ms-animation: fadeIn 0.5s;
}
@media only screen and (max-width: 600px) {
  .frame {
    height: 70%;
    margin: 10px 20px;
    width: 75%;
  }
}
</style>
