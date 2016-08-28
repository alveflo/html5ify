'use strict';
var cheerio = require('cheerio');
var reference = require('../reference/reference.json');
var colors = require("colors");
var PluginError = require('gulp-util').PluginError;
var path = require('path');
var _ = require('underscore');

function html5ify(filename, html) {
  var $ = cheerio.load(html);
  var unsupported = [];
  function traverse(obj) {
    if (obj.hasOwnProperty("children") && obj.children.length > 0) {
      for (var child in obj.children)
      {
        traverse(obj.children[child]);
      }
    }
    if (obj.attribs) {
      for (var attr in obj.attribs) {
        var validAttr = [];
        if (reference.hasOwnProperty(obj.name)) {
          validAttr.push(_.find(reference[obj.name], function(d) {
            return d.attribute == attr;
          }));
        }
        validAttr.push(_.find(reference["global"], function(d) {
          return d.attribute == attr;
        }));
        if (!validAttr[0]) {
          var unsupportedAttr = _.find(reference["unsupported"], function(d) {
            return d.attribute == attr;
          });
          if (unsupportedAttr) {
            unsupported.push(attr);
          } else {
            $(obj).attr("data-" + attr, obj.attribs[attr]);
            $(obj).removeAttr(attr);
          }
        }
      }
    }
  };

  traverse($("html")['0']);
  return {
    "html": $.html(),
    "unsupported": unsupported
  };
};

module.exports = function(options) {
  var opts = options || {};
  var through = require('through2');
  function Htmlify(file, enc, cb) {
    if (file.isBuffer()) {
      try {
        var result = html5ify(file.path, String(file.contents));
        if (result.unsupported.length > 0) {
          for (var attr in result.unsupported) {
            if (opts.throw) {
              throw path.basename(file.path).red.bold + " contains unsupported attribute " + result.unsupported[attr].red.bold;
            } else {
              console.log("(html5ify) - " + "Warning: ".red.bold + " " + path.basename(file.path).bold + " contains unsupported attribute " + result.unsupported[attr].bold);
            }
          }
        }
        file.contents = new Buffer(result.html);
      } catch (e) {
        return cb(new PluginError("html5ify", e));
      }
    }
    cb(null, file);
  };
  return through.obj(Htmlify);
};
