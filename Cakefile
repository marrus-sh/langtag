{ build , clear , configure , watch } = require 'Roost'

#  See <https://github.com/marrus-sh/Roost> for the meaning of this
#    configuration.
configure
  destination: "Build/"
  literate: yes
  name: "langtag"
  order: [ "README" ]
  preamble: "README.js"
  prefix: ""
  suffix: ".md"

task "build", "build langtag", build
task "watch", "build langtag and watch for changes", watch
task "clear", "remove built files", clear
