<template lang="jade">
.summary
  ul(v-if!="summary && summary.sections" v-for="s in summary.sections")
    li(v-if="s.link")
      a(v-link="'/' + s.link") {{s.title}}
    li(v-if="s.sections")
      ul(v-for="s in s.sections")
        li(v-if="s.link")
          a(v-link="'/' + s.link") {{s.title}}
        li(v-if="s.sections")
          ul(v-for="s in s.sections")
            li(v-if="s.link")
              a(v-link="'/' + s.link") {{s.title}}
            li(v-if="s.sections")
              ul(v-for="s in s.sections")
                li(v-if="s.link")
                  a(v-link="'/' + s.link") {{s.title}}
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
