<template lang="jade">
div
  summary(:summary="summary")
  content.clearfix
</template>

<script lang="coffee">
utils = require('./utils')
http = require('./utils/http')

Summary = require('./components/summary')
Content = require('./components/content')

exports.components =
  summary: Summary
  content: Content

exports.data = ->
  summary: {}

exports.ready = ->
  http('book/SUMMARY.json?' + Date.now().toString(36)).get((summary) =>
    utils.extend(window, summary)
    document.title = summary.title
    @summary = summary
  )
</script>

<style lang="stylus">
@import "styles/index"
</style>
