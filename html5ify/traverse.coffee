_ = require "underscore"
reference = require "../reference/reference.json"
$ = require "cheerio"

findAttribute = (attributeList, list, attribute) ->
  attr = _.find list, (d) ->
    return d.attribute == attribute
  attributeList.push attr if attr?
  return attributeList

traverseDom = ($, obj, unsupported) ->
  if obj.hasOwnProperty("children") and obj.children.length > 0
    for child in obj.children
      [$, unsupported] = traverseDom($, child, unsupported)

  if obj.attribs?
    for attr of obj.attribs
      validAttr = []
      if reference.hasOwnProperty obj.name
        validAttr = findAttribute validAttr, reference[obj.name], attr
      validAttr = findAttribute validAttr, reference["global"], attr

      if !validAttr[0]
        unsupportedAttr = findAttribute [], reference["unsupported"], attr
        if unsupportedAttr.length > 0
          unsupported.push attr
        else
          $(obj).attr "data-#{attr}", obj.attribs[attr]
          $(obj).removeAttr attr
  return [$, unsupported]

traverse = (obj) ->
  traverseDom(obj, obj("html")["0"], [])

module.exports = traverse
