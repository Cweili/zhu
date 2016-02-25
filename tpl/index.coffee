Vue = require('vue')

Zhu = require('./zhu')
router = require('./utils/router')

Vue.config.debug = true
Vue.config.silent = !Vue.config.debug

Vue.use(router)

app = new Vue
  el: 'body'
  components: zhu: Zhu

router.on(
  '/(\\S*)': (path) ->
    app.$broadcast('routeChange', path)
)

router.before(-> window.scrollTo(0, 0))
