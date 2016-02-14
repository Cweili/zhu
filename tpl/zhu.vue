<template lang="jade">
div
  summary(:summary="summary")
  content.clearfix(:prefix="prefix", :v="summary.v")
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
  prefix: 'book/'

exports.ready = ->
  http("#{@prefix}SUMMARY.json?#{utils.timehash()}").get((summary) =>
    document.title = summary.title
    @summary = summary
  )
</script>

<style lang="stylus">
@import "styles/index"
</style>
