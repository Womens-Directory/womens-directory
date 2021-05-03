<template>
  <div>
    <a v-if="!open" @click="open = true">
      <div class="feedback-closed">
        <i class="fa fa-comments"></i>
      </div>
    </a>

    <div class="feedback-open" v-else>
      <div class="px-3 py-3">
        <a @click="open = false">
          <i class="fa fa-times px-2 py-2 ml-2"></i>
        </a>
        <p>
          How can we make Women's Directory better? We'll use your feedback to
          improve the site.
        </p>
        <form class="form" id="feedback-form">
          <input type="hidden" value="<% request.path %>" />
          <div class="control mt-3">
            <p class="has-text-weight-bold">I found an issue with:</p>
            <label class="radio" v-for="category in categories" :key="category">
              <input
                class="ml-0 mr-1"
                type="radio"
                v-model="kind"
                :value="category.toLowerCase().replace(/ /g, '-')"
              />
              {{ category }}
            </label>
          </div>
          <div class="control mt-3">
            <p class="has-text-weight-bold">How can we improve?</p>
            <textarea class="textarea" v-model="body"></textarea>
          </div>
          <p class="is-italic mt-3">{{ error }}</p>
          <button
            @click="submit"
            class="button is-primary mt-3 mb-1"
            :disabled="error"
          >
            Send feedback
          </button>
        </form>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
const categories = ["The entire site", "This specific page", "Something else"];

export default {
  props: {
    currentPath: { type: String, required: true },
  },

  data: () => ({
    categories,
    open: true,
    body: "",
    kind: null,
  }),

  computed: {
    error() {
      if (!this.kind) return "Please select an issue category.";
      if (!this.body) return "Please tell us how we can improve.";
    },
  },

  methods: {
    submit(e: Event) {
      console.log("submit");
      e.preventDefault();
    },
  },
};
</script>

<style lang="scss">
.feedback-closed {
  position: fixed;
  bottom: 12px;
  right: 12px;
  width: 40px;
  height: 40px;
  border-radius: 20px;
  color: white;
  background-color: #3273dc;
  box-shadow: 0px 0px 6px 0px rgba(0, 0, 0, 0.6);

  &:hover {
    background-color: #363636;
  }

  i {
    margin-left: 12px;
    margin-top: 12px;
  }
}

.feedback-open {
  position: fixed;
  bottom: 0;
  right: 12px;
  margin-left: 12px;
  min-width: 200px;
  max-width: 500px;
  background-color: white;
  border: 1px solid #dbdbdb;
  box-shadow: 0px 0px 15px 0px rgba(0, 0, 0, 0.5);
  border-top-left-radius: 8px;
  border-top-right-radius: 8px;

  // override bulma and make radio buttons stack vertically
  label[class="radio"] {
    display: block;
  }

  .radio + .radio {
    margin-left: 0;
  }

  .fa-times {
    float: right;
  }
}
</style>
