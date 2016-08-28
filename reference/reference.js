var cheerio = require("cheerio");
var fs = require("fs");

var html = fs.readFileSync("reference.html", "utf8");
var $ = cheerio.load(html);
var jsonfile = require('jsonfile');

module.exports = function() {
  var x = 1;
  var attribute;
  var tags;
  var description;
  var data = {};

  var addtojson = function(attribute, tags, description) {
    for (var tag in tags) {
      tag = tags[tag];
      if (!data.hasOwnProperty(tag)) {
        data[tag] = [];
      }
      data[tag].push({ "attribute": attribute, "description": description });
    }
  };

  $('#ref tbody tr td').each( function(){
    if (x === 1) {
      attribute = $(this).text();
    } else if (x === 2) {
      tags = [];
      var regex = /<([a-z]+)>/g;
      var match = regex.exec($(this).text());
      if (match) {
        while (match) {
          tags.push(match[1]);
          match = regex.exec($(this).text());
        }
      } else {
        if ($(this).text() == "Not supported in HTML 5.") {
          tags.push("unsupported");
        } else {
          tags.push("global");
        }
      }
    } else if (x === 3) {
      x = 0;
      description = $(this).text();
      addtojson(attribute, tags, description);
    }
    x++;
  });

  jsonfile.writeFile("reference.json", data);

  return data;
}
