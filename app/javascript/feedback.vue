<template>
  <div>
    <a v-if="state == 'closed'" @click="state = 'open'">
      <div class="feedback-closed">
        <i class="fa fa-comments" />
      </div>
    </a>

    <div class="feedback-open" v-else-if="state != 'done'">
      <div class="px-3 py-3">
        <div v-if="state == 'submitted'">
          <a @click="state = 'done'" class="x px-2 py-1 ml-3">
            <i class="fa fa-times mr-1" />
            Close
          </a>
          <p>
            Thank you for sending us your feedback! We'll use it to improve the
            site.
          </p>
        </div>
        <div v-else>
          <a @click="state = 'closed'" class="x px-2 py-1 ml-3">
            <i class="fa fa-times mr-1" />
            Close
          </a>
          <p>
            How can we make Women's Directory better? We'll use your feedback to
            improve the site.
          </p>
          <form class="form" id="feedback-form">
            <input type="hidden" value="<% request.path %>" />
            <div class="control mt-3">
              <p class="has-text-weight-bold">What's wrong?</p>
              <label class="radio" v-for="cat in categories" :key="cat">
                <input
                  class="ml-0 mr-1"
                  type="radio"
                  v-model="category"
                  :value="cat"
                />
                {{ cat }}
              </label>
            </div>
            <div class="control mt-3">
              <p class="has-text-weight-bold">How can we improve?</p>
              <textarea class="textarea" v-model="body"></textarea>
            </div>
            <p class="is-italic mt-3" v-if="state == 'submitError'">
              Sorry, something went wrong. Please try again.
            </p>
            <p class="is-italic mt-3">{{ error }}</p>
            <button
              @click="submit"
              class="button is-info mt-3 mb-1"
              :disabled="error || state == 'submitting'"
            >
              {{ state == "submitting" ? "Submitting..." : "Send feedback" }}
            </button>
          </form>
        </div>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
const categories = [
  "Something is wrong with the entire site",
  "Something is wrong with this specific page",
  "I want to add a location to the site",
  "I have something else to suggest",
];

export default {
  props: {
    currentPath: { type: String, required: true },
  },

  data: () => ({
    categories,
    // states: closed, open, submitting, submitError, submitted, done
    state: "closed",
    body: "",
    category: null,
  }),

  computed: {
    error() {
      if (!this.category) return "Please select an issue category.";
      if (!this.body) return "Please tell us how we can improve.";
    },
  },

  methods: {
    async submit(e: Event) {
      e.preventDefault();
      if (this.error) return;

      const data = {
        category: this.category,
        body: this.body,
        path: this.currentPath,
      };
      this.state = "submitting";
      try {
        const resp = await window.fetch("/feedback", {
          method: "POST",
          credentials: "include",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify(data),
        });
        if (!resp.ok) {
          this.state = "submitError";
          return;
        }
        this.state = "submitted";
      } catch {
        this.state = "submitError";
        return;
      }
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

  .x {
    float: right;
  }
}
</style>
