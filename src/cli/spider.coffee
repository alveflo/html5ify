readDirectory = (directory, recurse, extension) ->
  fs = require "fs"
  path = require "path"
  content = fs.readdirSync directory
  files = []

  for file in content
    filePath = path.resolve directory, file
    stat = fs.statSync filePath
    if stat.isDirectory()
      files = files.concat readDirectory("#{directory}/#{file}"
        , recurse, extension) if recurse?
    else
      if filePath.endsWith(extension)
        files.push
          fullpath: filePath
          filename: file
          path: "#{directory}/#{file}"
          stat: stat
  return files

module.exports =
  scan: (dir, recurse, extension) ->
    readDirectory(dir, recurse, extension)
