<p align="center">
<img src="http://think-about.fr/wp-content/uploads/2015/07/html5-superheros.png" width="100"><br/>
<h1 align="center">html5ify</h1>
</p>
<p align="center">
<a href="https://www.npmjs.com/package/html5ify"><img src="https://img.shields.io/npm/v/npm.svg?maxAge=2592000"/></a>
<a href="https://www.npmjs.com/package/html5ify"><img src="https://img.shields.io/npm/dm/localeval.svg?maxAge=2592000"/></a>
<a href="https://www.npmjs.com/package/html5ify"><img src="https://img.shields.io/npm/l/express.svg?maxAge=2592000"/></a>
</p>
HTML5 validator and migration helper which adds `data`-prefix to all custom attributes in html documents and verifies that no obsolete/unsupported attributes is used. Attribute list is based on [W3 attribute reference](http://www.w3schools.com/tags/ref_attributes.asp)

## Installation
```
$ (sudo) npm install html5ify --global
```

## CLI
html5ify ships with a cli application which can be used as a reference to ensure which attributes that's valid for given html tags.
### Options
```
Usage: html5ify [options]

Options:

  -h, --help         output usage information
  -V, --version      output the version number
  list <tag>         Get all valid attributes for given <tag>
  -g, --globals      Get all valid global attributes
  -u, --unsupported  Get all unsupported attributes in HTML5
```
## Gulp
### Options
`throw` set this to `true` if you want gulp to throw an exception if unsupported/obsolete HTML attributes was found in any document.
### Example
#### gulpfile.js
```javascript
var html5ify = require("html5ify");
var gulp = require("gulp");

gulp.task("html5ify", function() {
  return gulp.src("*.html")
    .pipe(html5ify({
      throw: true
    }))
    .pipe(gulp.dest("./comp"));
});
```
#### Input
```html
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title>Some title</title>
</head>
  <body>
    <div id="foo" ng-app="myApp" ng-controller="myCtrl">
      <input type="text" ng-model="firstName" />
      <input type="text" ng-model="lastName" />
    </div>
  </body>
</html>
```
#### Output
```html
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title>Some title</title>
</head>
  <body>
    <div id="foo" data-ng-app="myApp" data-ng-controller="myCtrl">
      <input type="text" data-ng-model="firstName">
      <input type="text" data-ng-model="lastName">
    </div>
  </body>
</html>

```
## License
The MIT License (MIT)

Copyright (c) 2016 victor

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
