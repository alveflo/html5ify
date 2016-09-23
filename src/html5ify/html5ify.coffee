cheerio = require "cheerio"
colors = require "colors"
PluginError = require("gulp-util").PluginError
path = require "path"
through = require "through2"
traverse = require "./traverse.js"
fs = require "fs"
_ = require "underscore"

html5ify = (html) ->
  html = cheerio.load html
  [$, unsupported, modified] = traverse html, [], []
  {
    html: $.html()
    unsupported: unsupported
    modified: modified
  }

module.exports = {
  gulp: (options) ->
    opts = options or {}
    Htmlify = (file, enc, cb) ->
      errorMsg = (file, attr) ->
        return "(" + "html5ify".yellow + "): " +
          path.basename(file.path).red.bold +
          " contains unsupported attribute " +
          result.unsupported[attr].red.bold

      if file.isBuffer()
        try
          result = html5ify String(file.contents)

          if result.unsupported.length > 0
            if opts.throw
              for attr of result.unsupported
                console.log errorMsg(file, attr.attribute)
              throw path.basename(file.path).red.bold +
                " contains unsupported attribute(s)."
            else
              for attr of result.unsupported
                console.log "(" + "html5ify".yellow + "): " +
                  "Warning!".red.bold + " " +
                  path.basename(file.path).bold +
                  " contains unsupported attribute " +
                  attr.attribute.bold
          file.contents = new Buffer result.html
        catch e
          return cb new PluginError("html5ify", e)
      cb null, file
      return
    return through.obj Htmlify
  program: (filename) ->
    content = fs.readFileSync filename, "utf8"
    return html5ify content
}
