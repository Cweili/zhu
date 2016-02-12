<template lang="jade">
article
  .content(v-if="content" transition="v") {{{content}}}
</template>

<script lang="coffee">
utils = require('../utils')
http = require('../utils/http')

load = (vm, section) ->
  vm.content = ''
  chapter = section.split('/')
  chapter = if chapter.length > 1 then chapter[0] + '/' else ''
  http("#{vm.prefix}#{section}.html?#{vm.v || utils.timehash()}").get((content) ->
    vm.content = content.replace(/<img src=(.+?)( alt=.+?)?>/g, ($0, $1, $2) ->
      img = '<img class=img-responsive src='
      v = "?#{vm.v}"
      if $1.indexOf('//') < 0
        "#{img}#{vm.prefix}#{chapter}#{$1}#{v}#{$2}>"
      else if $1.indexOf('../') >= 0
        "#{img}#{$1.substr(3)}#{v}#{$2}>"
      else
        "#{img}#{$1}#{$2}>"
    )
  )

exports.props = [
  'prefix'
  'v'
]

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
