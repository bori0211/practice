<template>
  <div>
    <h1>Trade of View your Portfolio</h1>
    <h6>You may Save & Load your Data</h6>
    <hr>
    <p>Your Funds: {{ funds | currency }}</p>
  </div>
</template>

<script>
export default {
  computed: {
    funds() {
      return this.$store.getters.funds;
    }
  }
}
</script>
