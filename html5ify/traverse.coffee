findAttribute = (attributeList, list, attribute) ->
    attr = _.find list, (d) ->
        return d.attribute == attribute
    attributeList.push attr
    return attributeList

traverse = (obj) ->
    unsupported = []
    if obj.hasOwnProperty 'children' and obj.children.length > 0
        traverse child for child in obj.children
    
    if obj.attribs
        _.each obj.attribs, (attr) ->
            validAttr = []
            if reference.hasOwnProperty obj.name
                validAttr.push(findAttribute reference[obj.name], attr)
                validAttr = findAttribute reference[obj.name], attr
            validAttr = findAttribute reference['global'], attr

            unless validAttr[0]
                unsupportedAttr = findAttribute reference['unsupported'], attr
                unsupported.push unsupportedAttr if unsupportedAttr? is true
                unless unsupportedAttr
                    $(obj).attr 'data-#{attr}', obj.attribs[attr]
                    $(obj).removeAttr attr
    return unsupported

module.exports = traverse