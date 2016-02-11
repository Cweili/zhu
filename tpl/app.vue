<template lang="jade">
div
  summary(:summary="summary")
  router-view#zhu.container-fluid(transition transition-mode="out-in")
</template>

<script lang="coffee">
utils = require('./utils')
http = require('./utils/http')

Summary = require('./components/summary')

exports.components = {
  summary: Summary
}

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

#zhu
  @media (min-width: $grid-float-breakpoint)
    padding-left: ($summary-width + $grid-gutter-width)
    padding-right: $grid-gutter-width
  &.v
    &-transition
      transition: all .3s
      transform-origin: 50% 100%
      z-index: 1
    &-enter
    &-leave
      absolute: top 0 left 0
      width: 100%
      transform: scale3d(.9, .9, .9)
      opacity: 0
</style>
