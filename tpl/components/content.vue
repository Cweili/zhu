<template lang="jade">
.content
  h1 {{title}}
  div {{{content}}}
</template>

<script lang="coffee">
http = require('../utils/http')

load = (vm, section) ->
  http("book/#{section}.html?#{window.v}").get((content) ->
    vm.content = content
    vm.title = window.title
  )

exports.data = ->
  content: ''
  title: ''

exports.ready = ->
  @$on('routeChange', (section) =>
    console.info(1)
    if section then load(@, section) else @$router.go('/README')
  )
</script>

<style lang="stylus">
@import "../styles/variables"
@import "../styles/mixins"

.content
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
