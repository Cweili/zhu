utils = require('./')

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

module.exports = -> utils.nextTick(prism.highlightAll)
