<template lang="jade">
.section
  h1 {{title}}
  {{{content}}}
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

exports.watch =
  '$route.params.section': (section) ->
    load(@, section)

exports.ready = ->
  section = @$route.params.section
  if section then load(@, section) else @$router.go(path: 'README')
</script>
