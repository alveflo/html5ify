cheerio = require 'cheerio'
reference = require '../reference/reference.json'
colors = require 'colors'
PluginError = require('gulp-util').PluginError
path = require 'path'
_ = require 'underscore'
traverse = require 'traverse'

html5ify = (filename, html) ->
    $ = cheerio.load html
    unsupported = traverse $('html')['0']
    return {
        'html': $.html()
        'unsupported': unsupported
    }

module.exports = (options) ->
    opts = options or {}
    through = require 'through2'
    
    Htmlify = (file, enc, cb) ->
        Throw = (file, attr) ->
            throw path.basename(file.path).red.bold + 
                    " contains unsupported attribute " + 
                    result.unsupported[attr].red.bold;
        if file.isBuffer()
            try
                result = html5ify file.path, String(file.contents)
                if result.unsupported.length > 0
                    if opts.throw
                        Throw attr for attr in result.unsupported
                    else
                        console.log "(html5ify) - " + 
                        "Warning: ".red.bold + " " + 
                        path.basename(file.path).bold + 
                        " contains unsupported attribute " + 
                        result.unsupported[attr].bold
            catch e 
                return cb new PluginError("html5ify", e)
            cb null, file
        return through.obj Htmlify