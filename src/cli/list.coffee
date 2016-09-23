Table = require "cli-table"
colors = require "colors"
reference = require "../../reference/reference.json"

printValidAttributes = (tag) ->
  if reference.hasOwnProperty tag
    attrs = reference[tag]
    table = new Table {
      head: ["Attribute".green, "Description".green]
    }
    table.push [x.attribute, x.description] for x in attrs
    console.log table.toString()
  return

module.exports = (program) ->
  if program.list
    if reference.hasOwnProperty program.list
      console.log "\n * Valid attributes for " +
        program.list.bold +
        ". Note that this is tag specific attributes, \
        pass -g/--global for global attributes.\n"
      printValidAttributes program.list
    else
      console.log "No tag specific attributes for \"" +
      program.list.bold +
      "\" was found. Pass -g/--global for global attributes."
    return

  if program.globals
    console.log "\n * Global attributes\n"
    printValidAttributes "global"
    return

  if program.unsupported
    console.log "\n * Unsupported attributes in HTML5\n"
    printValidAttributes "unsupported"
