test "Html5ify should return 2 errors", () ->
    path = require "path"
    html5ify = require "../lib/html5ify/html5ify.js"
    html5ify = html5ify.program
    
    res = html5ify path.join process.cwd(), "__tests__/html/test.html"
    expect(res.unsupported.length).toBe 2

test "html5ify should return 3 modifications", () ->
    path = require "path"
    html5ify = require "../lib/html5ify/html5ify.js"
    html5ify = html5ify.program
    
    res = html5ify path.join process.cwd(), "__tests__/html/test.html"
    expect(res.modified.length).toBe 3
    