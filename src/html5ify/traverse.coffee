_ = require "underscore"
reference = require "../../reference/reference.json"
$ = require "cheerio"

findAttribute = (attributeList, list, attribute) ->
  attr = _.find list, (d) ->
    return d.attribute == attribute
  attributeList.push attr if attr?
  return attributeList

traverseDom = ($, obj, unsupported, modified) ->
  if obj.hasOwnProperty("children") and obj.children.length > 0
    for child in obj.children
      [$, unsupported, modified] = traverseDom($, child, unsupported, modified)

  if obj.attribs?
    for attr of obj.attribs
      validAttr = []
      if reference.hasOwnProperty obj.name
        validAttr = findAttribute validAttr, reference[obj.name], attr
      validAttr = findAttribute validAttr, reference["global"], attr

      if !validAttr[0]
        nodeName = $(obj).prop('nodeName').toLowerCase()
        element = $(obj).clone().empty().toString()
        element = element.replace "</#{nodeName}>", ""
        unsupportedAttr = findAttribute [], reference["unsupported"], attr
        if unsupportedAttr.length > 0
          unsupported.push {
            attribute: unsupportedAttr[0].attribute
            description: unsupportedAttr[0].description
            element: element
          }
        else
          unless attr.toLowerCase().startsWith("data-")
            $(obj).attr "data-#{attr}", obj.attribs[attr]
            $(obj).removeAttr attr
            modified.push {
              attribute: attr
              element: element
            }
  return [$, unsupported, modified]

traverse = (obj) ->
  traverseDom(obj, obj("html")["0"], [], [])

module.exports = traverse
