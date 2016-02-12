Vue = require('vue')

App = require('./app')
router = require('./utils/router')

Vue.config.debug = true
Vue.config.silent = !Vue.config.debug

Vue.use(router)

app = new Vue
  el: 'body'
  components: app: App

router.on(
  '/(\\S*)': (path) ->
    console.info(2)
    app.$broadcast('routeChange', path)
)

router.before(-> window.scrollTo(0, 0))
