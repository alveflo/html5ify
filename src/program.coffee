#!/usr/bin/env node
pjson = require "../package.json"
program = require "commander"
listPrinter = require "./cli/list.js"
linter = require "./cli/linter.js"

program
  .version pjson.version
    .option "-l, --list <tag>", "Get all valid attributes for given <tag>"
    .option "-d, --dir <path>", "Specifies directory to process"
    .option "-f, --file <filename>", "Specifies file to process"
    .option "-r, --recurse", "Reads directory recursively"
    .option "-o, --out <path>", "Specifies output directory"
    .option "-g, --globals", "Get all valid global attributes"
    .option "-u, --unsupported", "Get all unsupported attributes in HTML5"
    .parse process.argv

listPrinter program
linter program
