Vue = require('vue')
Router = require('vue-router')

App = require('./app')
Section = require('./views/section')

Vue.config.debug = true
Vue.config.silent = !Vue.config.debug

# 注册路由插件
Vue.use(Router)

router = new Router(
  linkActiveClass: 'active'
)

router.map
  '/':
    component: Section
  '/*section':
    component: Section

router.beforeEach -> window.scrollTo(0, 0)

router.start(App, '#app')
