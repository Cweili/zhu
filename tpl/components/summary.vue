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

aside.summary
  header.header
    h1.title
      button.toggle(type="button" @focus="toggle = true" @blur="toggle = false")
      | {{summary.title}}
  nav.menu(:class="{off: !toggle}")
    ul.chapter(v-if!="summary && summary.list" v-for="a in summary.list")
      | !{list(5)}
</template>

<script lang="coffee">
exports.props = [
  'summary'
]

exports.data = ->
  path: ''
  toggle: false

exports.ready = ->
  @$on('routeChange', (path) => @path = path)
</script>

<style lang="stylus">
@import "../styles/variables"
@import "../styles/mixins"

.summary
  .header
    fixed: top 0 left 0
    height: $navbar-height

  .menu
    fixed: top $navbar-height bottom 0 left 0
    width: $summary-width
    background: $body-bg
    overflow: hidden
    overflow-y: auto
    z-index: $zindex-navbar-fixed
    ul
      list-style: none
      margin: 0
      padding-left: $grid-gutter-width
      font-size: $font-size-h6
      &.chapter
        font-size: $font-size-h4
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

  .toggle
    $toggle-height = $font-size-h1
    display: none
    position: relative
    margin-right: 8px
    size: 48px $toggle-height
    touch-action: manipulation
    cursor: pointer
    background-image: none // Reset unusual Firefox-on-Android default style see https://github.com/necolas/normalize.css/issues/214
    border: 1px solid transparent
    border-radius: $btn-border-radius-base
    user-select: none

    button-variant: $btn-default-color $btn-default-bg $btn-default-border

    &,
    &:active,
    &.active
      &:focus,
      &.focus
        tab-focus()

    &:hover,
    &:focus,
    &.focus
      color $btn-default-color
      text-decoration none

    &:active,
    &.active
      outline 0
      background-image none
      box-shadow inset 0 3px 5px rgba(0, 0, 0, .125)

    &:after
      content: ""
      absolute: top 50% left $padding-base-horizontal right $padding-base-horizontal
      border: 1px solid $text-color
      box-shadow: 0 (ceil($toggle-height / -4) + 1) $text-color,
                  0 (ceil($toggle-height / 4) - 1) $text-color

  .title
    padding-left: $grid-gutter-width

  @media (max-width: $grid-float-breakpoint-max)
    .header
      position: static

    .menu
      width: 100%
      transition: all .3s
      &.off
        transform: translate3d(-100%, 0, 0)

    .toggle
      display: inline-block
</style>
