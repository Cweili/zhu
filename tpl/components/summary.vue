<template lang="jade">
- function list(level, total) {
-   if (level) {
      li(v-if="a.link")
        a.text-ellipsis(
          class="level-" + (total - level)
          v-href="'/' + a.link",
          :class="{active: path == a.link}"
        ) {{a.title}}
      li(v-if="a.list")
        ul(v-for="a in a.list")
          | !{list(--level, total)}
-   }
- }

aside.summary
  header.header
    h2.title.text-ellipsis
      button.toggle(type="button" @focus="toggle = true" @blur="toggle = false")
      | {{summary.title}}
  nav.menu(:class="{off: !toggle}")
    ul.chapter(v-if!="summary && summary.list" v-for="a in summary.list")
      | !{list(5, 5)}
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
    padding: $line-height-computed 0
    size: $summary-width ($navbar-height + $line-height-computed * 2)

  .menu
    fixed: top ($navbar-height + $line-height-computed * 2) bottom 0 left 0
    width: $summary-width
    background: $body-bg
    overflow: hidden
    overflow-y: auto
    z-index: $zindex-navbar-fixed
    ul
      list-style: none
      margin: 0
      padding: 0
      font-size: $font-size-h6
      &.chapter
        font-size: $font-size-h4
      > li > a
        display: block
        position: relative
        padding: $padding-base-vertical 0
        background: $body-bg
        color: $text-color
        text-decoration: none
        transition: all .3s
        &:after
          content: ""
          absolute: top 0 bottom 0 left 0
          border: 2px solid $component-active-bg
          transform: scaleY(0)
          transition: all .3s
        &:focus
        &:active
        &:hover
        &.active
          background: $summary-active
        &.active
          color: $state-primary-text
          &:after
            transform: scaleY(1)

        for $level in 0..4
          &.level-{$level}
            padding-left: ($grid-gutter-width * ($level + 1))

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
      color: $btn-default-color
      text-decoration: none

    &:active,
    &.active
      outline: 0
      background-image: none
      box-shadow: inset 0 3px 5px rgba($black, .125)

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
      padding: 0
      size: 100% $navbar-height

    .menu
      top: $navbar-height
      width: 100%
      transition: all .3s
      &.off
        transform: translate3d(-100%, 0, 0)

    .toggle
      display: inline-block
</style>
