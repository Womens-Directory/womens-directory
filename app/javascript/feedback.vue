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
          <i class="fa fa-times"></i>
        </a>
        <p>
          How can we make Women's Directory better? We'll use your feedback to
          improve the site.
        </p>
        <form class="form" id="feedback-form" method="POST">
          <input type="hidden" value="<% request.path %>" />
          <div class="control mt-3">
            <p class="has-text-weight-bold">I found an issue with:</p>
            <label class="radio">
              <input
                class="ml-0 mr-1"
                type="radio"
                name="kind"
                value="entire-site"
              />
              The entire site
            </label>
            <label class="radio">
              <input
                class="ml-0 mr-1"
                type="radio"
                name="kind"
                value="specific-page"
              />
              This specific page
            </label>
            <label class="radio">
              <input
                class="ml-0 mr-1"
                type="radio"
                name="kind"
                value="something-else"
              />
              Something else
            </label>
          </div>
          <div class="control mt-3">
            <p class="has-text-weight-bold">How can we improve?</p>
            <textarea
              class="textarea"
              id="feedback-body"
              name="body"
            ></textarea>
          </div>
          <input
            class="button is-primary mt-3"
            form="feedback-form"
            type="submit"
            value="Send feedback"
          />
        </form>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
export default {
  data: () => ({
    open: false,
  }),
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
