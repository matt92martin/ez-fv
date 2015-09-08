module.exports =
class EzFvView
    serialize: ->

    destroy:->

    getLines:(input) ->
        lines = input.split('\n')
        ines = (x.trim() for x in lines)
        return lines

    getLabels: (input) ->
        lines = @getLines(input)
        AA = /^\s*(?:r|c|ch)?([A-Z0-9]{1,4})[\s:.\)]+(\w+)\s*$/
        ZZ = /^\s*(.*)\s*$/
        labels = []
        for x in lines
            mAA = AA.exec(x)
            mZZ = ZZ.exec(x)
            if mAA
                if mAA[2] != ""
                    labels.push([mAA[1], mAA[2]])
            else
                if labels.length > 0
                    nextVal = parseInt(labels[labels.length-1][0]) + 1
                else
                    nextVal = 1
                if mZZ[1] != ""
                    labels.push([nextVal, mZZ[1]])

        return labels

    makeItems: (lines, type, label, oe)->
        items = ""
        for x in lines
            extra = ""
            specify = /^.*(specify).*$/i
            if specify.test(x) && oe
                extra = " open=\"1\" openSize=\"25\" randomize=\"0\""
            items += "\t<#{type} label=\"#{label}#{x[0]}\"#{extra}>#{x[1]}</#{type}>\n"
        if type == "case"
            nNum = parseInt(lines[lines.length-1][0]) + 1
            items += "\t<#{type} label=\"c#{nNum}\">Bad pipe</#{type}>"
        console.log items
        return items

    insertItems: (items)->
        @editor.setTextInBufferRange(@selRange, items,)


    getEditor: ->
        @editor = atom.workspace.getActiveTextEditor()
        @buffer = @editor.getBuffer()
        @selRange = @editor.getLastSelection().getBufferRange()
        @input = @editor.getTextInBufferRange(@selRange)
        # input = @buffer.getText() #gets alllllll text

    rows: ->
        @getEditor()
        lines = @getLabels(@input)
        items = @makeItems(lines, "row", "r", true)
        @insertItems(items)
        return true

    cols: ->
        @getEditor()
        lines = @getLabels(@input)
        items = @makeItems(lines, "col", "c", true)
        @insertItems(items)
        return true

    choices: ->
        @getEditor()
        lines = @getLabels(@input)
        items = @makeItems(lines, "choice", "ch", false)
        @insertItems(items)
        return true

    cases: ->
        @getEditor()
        lines = @getLabels(@input)
        items = @makeItems(lines, "case", "c", false)
        @insertItems(items)
        return true

    strip: ->
        @getEditor()
        inputLines = @input.split('\n')
        stripped = ""
        for x in inputLines
            x = x.trim()
            notags = ""
            if x != ""
                tags = /^<[^>]*>(.*)<\/[^>]*>$/
                notags= tags.exec(x)
            if notags
                stripped += notags[1] + "\n"
            else
                stripped += x + "\n"

        @editor.setTextInBufferRange(@selRange, stripped,)
        return true






#Prototype declarations
String.prototype.trim = ->
    return String(this).replace(/^\s+|\s+$/g, '');
