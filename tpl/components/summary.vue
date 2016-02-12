<template lang="jade">
.summary
  ul(v-if!="summary && summary.list" v-for="a in summary.list")
    li(v-if="a.link")
      a(v-href="'/' + a.link") {{a.title}}
    li(v-if="a.list")
      ul(v-for="a in a.list")
        li(v-if="a.link")
          a(v-href="'/' + a.link") {{a.title}}
        li(v-if="a.list")
          ul(v-for="a in a.list")
            li(v-if="a.link")
              a(v-href="'/' + a.link") {{a.title}}
            li(v-if="a.list")
              ul(v-for="a in a.list")
                li(v-if="a.link")
                  a(v-href="'/' + a.link") {{a.title}}
</template>

<script lang="coffee">
exports.props = [
  'summary'
]
</script>

<style lang="stylus">
@import "../styles/variables"
@import "../styles/mixins"

.summary
  fixed: top 0 bottom 0 left 0
  width: $summary-width
  overflow: hidden
  overflow-y: auto
  ul
    list-style: none
    margin: 0
    padding-left: $grid-gutter-width
    > li > a
      display: block
      padding: $padding-base-vertical 0
      color: $text-color
      text-decoration: none
      &:focus
      &:active
      &:hover
      &.active
        color: $component-active-color
        background: $component-active-bg
</style>
