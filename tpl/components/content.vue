<template lang="jade">
article
  .content(v-if="content" transition="v") {{{content}}}
</template>

<script lang="coffee">
utils = require('../utils')
http = require('../utils/http')

prism = require('prismjs/components/prism-core')
require('prismjs/components/prism-markup')
require('prismjs/components/prism-css')
require('prismjs/components/prism-clike')
require('prismjs/components/prism-javascript')
require('prismjs/components/prism-c')
require('prismjs/components/prism-cpp')
require('prismjs/components/prism-csharp')
require('prismjs/components/prism-coffeescript')
require('prismjs/components/prism-jade')
require('prismjs/components/prism-json')
require('prismjs/components/prism-python')
require('prismjs/components/prism-stylus')
require('prismjs/plugins/line-numbers/prism-line-numbers')

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
    utils.nextTick(prism.highlightAll)
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
  .page-header
    margin-top: 0
  pre.line-numbers
    padding-left: 3.8em
</style>
