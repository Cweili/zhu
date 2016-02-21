<template lang="jade">
article
  .content(v-if="content" transition="v") {{{content}}}
</template>

<script lang="coffee">
utils = require('../utils')
http = require('../utils/http')
parser = require('../utils/parser')
syntaxHighlight = require('../utils/syntax-highlight')

load = (vm, section) ->
  vm.content = ''
  http("#{vm.prefix}#{section}.html?#{vm.v || utils.timehash()}").get((content) ->
    vm.content = parser(content, section, vm.prefix, vm.v)
    syntaxHighlight()
  , (text, xhr) ->
    vm.content = "<h1>#{xhr.status}</h1>#{text}"
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

@import "../../node_modules/prismjs/themes/prism"
@import "../../node_modules/prismjs/plugins/line-numbers/prism-line-numbers.css"

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

  h2
  h3
  h4
  h5
  h6
    margin-top: ($line-height-computed * 1.5)

  .page-header
    margin-top: 0

  pre.line-numbers
    padding-left: 3.8em
  .line-numbers-rows
    border-color: $pre-border-color
</style>
