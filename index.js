#!/usr/bin/env node
var reference = require("./reference/reference.json");
var pjson = require('./package.json');
var program = require("commander");
var Table = require('cli-table');
var colors = require('colors');

program
  .version(pjson.version)
  .option("list <tag>",           "Get all valid attributes for given <tag>")
  .option("-g, --globals",        "Get all valid global attributes")
  .option("-u, --unsupported",    "Get all unsupported attributes in HTML5")
  .parse(process.argv);

var printValidAttributes = function(tag) {
  if (reference.hasOwnProperty(tag)) {
    var attrs = reference[tag];
    var table = new Table({
      head: ["Attribute".green, "Description".green]
    });
    for (var attr in attrs) {
      attr = attrs[attr];
      table.push([attr.attribute, attr.description]);
    }
    console.log(table.toString());
  }
};

if (program.list) {
  if (reference.hasOwnProperty(program.list)) {
    console.log("\n * Valid attributes for " + program.list.bold + ". Note that this is tag specific attributes, pass -g/--global for global attributes.\n");
    printValidAttributes(program.list);
  } else {
    console.log("No tag specific attributes for \"" + program.list.bold + "\" was found. Pass -g/--global for global attributes.");
  }
}

if (program.globals) {
  console.log("\n * Global attributes\n");
  printValidAttributes("global");
}

if (program.unsupported) {
  console.log("\n * Unsupported attributes in HTML5\n");
  printValidAttributes("unsupported");
}
