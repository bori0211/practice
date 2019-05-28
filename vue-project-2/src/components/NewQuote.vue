<template>
  <div class="row">
    <form action="">
      <div class="col-sm-8 col-sm-offset-2 col-xs-12 form-group">
        <label>Quote</label>
        <textarea class="form-control" rows="3" v-model="quote"></textarea>
      </div>
      <div class="col-sm-8 col-sm-offset-2 col-xs-12 form-group">
        <button class="btn btn-primary" @click.prevent="createNew">Add Quote</button>
      </div>
    </form>
  </div>
</template>

<script>
export default {
  data: function() {
    return {
      quote: ""
    };
  },
  methods: {
    createNew() {
      this.$emit("quoteAdded", this.quote);
      this.quote = "";
    }
  }
}
</script>
