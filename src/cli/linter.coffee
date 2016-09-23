html5ify = require("../html5ify/html5ify.js").program
colors = require "colors"
figures = require "figures"
spider = require "./spider.js"
path = require "path"
mkdirp = require "mkdirp"
fs = require "fs"

lint = (file) ->
  result = html5ify file
  if result.unsupported.length > 0
    console.log " #{figures.cross} #{file.red.bold}"
    for error in result.unsupported
      console.log "  #{figures.cross} Obsolete: \
        #{error.attribute.red.bold} \
        (#{error.description})"
    return {
      modifications: 0
      errors: result.unsupported.length
      html: result.html
    }
  console.log " #{figures.tick} #{file.green.bold}"
  for modified in result.modified
    element = modified.element
    element = element.replace(modified.attribute, \
      "data-#{modified.attribute.yellow}".bold.green)
    console.log "  #{figures.tick} #{'Modified:'.yellow.bold} #{element}"
  return {
    modifications: result.modified.length
    errors: result.unsupported.length
    html: result.html
  }

saveFile = (content, filename, out) ->
  dir = path.join out, path.dirname filename
  out = path.join process.cwd(), out
  if !fs.existsSync dir
    mkdirp.sync dir, (err) ->
      if err
        console.error err
  dir = path.join out, filename
  fs.writeFileSync dir, content, null, (err) ->
    if err
      console.error err

module.exports = (program) ->
  if program.file
    result = lint program.file
    if program.out
      if result.errors.length == 0
        saveFile result.html, program.file, program.out
  if program.dir
    modifications = 0
    errors = 0
    files = spider.scan program.dir
      , program.recurse
      , program.extension || ".html"
    for file in files
      result = lint file.path
      modifications += result.modifications
      errors += result.errors
    if errors == 0
      if program.out
        for file in files
          saveFile result.html, file.path, program.out

    msg = "#{figures.tick} #{'Ok!'.green.bold} #{figures.pointerSmall.bold}"
    if errors > 0
      msg = "#{figures.cross} #{'Lint!'.red.bold} #{figures.pointerSmall.bold}"
    console.log "\n #{msg}
      #{errors} errors and
      #{modifications} modifications in #{files.length} files"
