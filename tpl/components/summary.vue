<template lang="jade">
- function list(level) {
-   if (level) {
      li(v-if="a.link")
        a(v-href="'/' + a.link", :class="{active: path == a.link}") {{a.title}}
      li(v-if="a.list")
        ul(v-for="a in a.list")
          | !{list(--level)}
-   }
- }

.summary
  h1.title {{summary.title}}
  ul(v-if!="summary && summary.list" v-for="a in summary.list")
    | !{list(5)}
</template>

<script lang="coffee">
exports.props = [
  'summary'
]

exports.data = ->
  path: ''

exports.ready = ->
  @$on('routeChange', (path) => @path = path)
</script>

<style lang="stylus">
@import "../styles/variables"
@import "../styles/mixins"

.summary
  fixed: top 0 bottom 0 left 0
  width: $summary-width
  overflow: hidden
  overflow-y: auto
  .title
    padding-left: $grid-gutter-width
  ul
    list-style: none
    margin: 0
    padding-left: $grid-gutter-width
    > li > a
      display: block
      position: relative
      padding: $padding-base-vertical 0
      color: $text-color
      text-decoration: none
      transition: all .3s
      &:after
        content: ""
        absolute: top 0 bottom 0 left ($grid-gutter-width * -5) right 0
        border-radius: $border-radius-base
        transform: scaleX(0)
        transform-origin: 0 50%
        transition: all .3s
        z-index: -1
      &:focus
      &:active
      &:hover
      &.active
        color: $component-active-color
        &:after
          background: ($component-active-bg + 50%)
          transform: scaleX(1)
      &.active
        &:after
          background: $component-active-bg
</style>
