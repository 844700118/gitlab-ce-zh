<script>
/**
 * Renders the stop "button" that allows stop an environment.
 * Used in environments table.
 */
import eventHub from '../event_hub';
import loadingIcon from '../../vue_shared/components/loading_icon.vue';
import tooltip from '../../vue_shared/directives/tooltip';

export default {
  props: {
    stopUrl: {
      type: String,
      default: '',
    },
  },

  directives: {
    tooltip,
  },

  data() {
    return {
      isLoading: false,
    };
  },

  components: {
    loadingIcon,
  },

  computed: {
    title() {
      return 'Stop';
    },
  },

  methods: {
    onClick() {
      // eslint-disable-next-line no-alert
      if (confirm('您确定要停止这个运行环境？')) {
        this.isLoading = true;

        $(this.$el).tooltip('destroy');

        eventHub.$emit('postAction', this.stopUrl);
      }
    },
  },
};
</script>
<template>
  <button
    v-tooltip
    type="button"
    class="btn stop-env-link hidden-xs hidden-sm"
    data-container="body"
    @click="onClick"
    :disabled="isLoading"
    :title="title"
    :aria-label="title">
    <i
      class="fa fa-stop stop-env-icon"
      aria-hidden="true" />
    <loading-icon v-if="isLoading" />
  </button>
</template>
