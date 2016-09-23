html5ify = require("../html5ify/html5ify.js").program
colors = require "colors"
figures = require "figures"
spider = require "./spider.js"

lint = (file) ->
  result = html5ify file
  if result.unsupported.length > 0
    console.log " #{figures.cross} #{file.red.bold}"
    for error in result.unsupported
      console.log "  #{figures.cross} Obsolete: \
        #{error.attribute.red.bold} \
        (#{error.description})"
    return [0, result.unsupported.length]
  console.log " #{figures.tick} #{file.green.bold}"
  for modified in result.modified
    element = modified.element
    element = element.replace(modified.attribute, \
      "data-#{modified.attribute.yellow}".bold.green)
    console.log "  #{figures.tick} #{'Modified:'.yellow.bold} #{element}"
  return [result.modified.length, 0]

module.exports = (program) ->
  if program.file
    lint program.file

  if program.dir
    modifications = 0
    errors = 0
    files = spider.scan program.dir
      , program.recurse
      , program.extension || ".html"
    for file in files
      result = lint file.path
      modifications += result[0]
      errors += result[1]
    msg = "#{figures.tick} #{'Ok!'.green.bold} #{figures.pointerSmall.bold}"
    if errors > 0
      msg = "#{figures.cross} #{'Lint!'.red.bold} #{figures.pointerSmall.bold}"
    console.log "\n #{msg}
      #{errors} errors and
      #{modifications} modifications in #{files.length} files"
