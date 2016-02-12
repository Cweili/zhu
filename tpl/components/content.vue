<template lang="jade">
article
  .content(v-if="content" transition="v") {{{content}}}
</template>

<script lang="coffee">
http = require('../utils/http')

load = (vm, section) ->
  vm.content = ''
  http("book/#{section}.html?#{window.v}").get((content) -> vm.content = content)

exports.data = ->
  content: ''

exports.ready = ->
  @$on('routeChange', ({0: section}) =>
    if section then load(@, section) else @$router.go('/README')
  )
</script>

<style lang="stylus">
@import "../styles/variables"
@import "../styles/mixins"

.content
  padding: $grid-gutter-width
  @media (min-width: $grid-float-breakpoint)
    padding-left: ($grid-gutter-width + $summary-width)
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
