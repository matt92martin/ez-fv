module.exports =
class InsertNumbersView

    constructor: (serializedState) ->
        @element = document.createElement('div')
        @element.id = 'insert-numbers'
        @input = document.createElement('input')
        @input.setAttribute('type', 'text')
        @input.id = "enterVal"
        @input.classList.add('native-key-bindings')
        @element.appendChild(@input)
        @input.addEventListener 'keydown', (e) => @pressEnter(e)
        @input.addEventListener 'blur', (e) => @cancel()

    serialize: ->

    destroy: ->
        @element.remove()

    pressEnter: (e) ->
        e.stopPropagation()
        key = e.which || e.keyCode
        if key == 13
            value = @getElementVal(e)
            @insertNums(value)
        else if key == 27
            @cancel()

    getElementVal: ->
        inputVal = document.getElementById('enterVal')
        @cancel()
        return inputVal.value

    toggle: (editor)->
        if @panel?.isVisible()
            @cancel()
        else
            @editor = editor
            @show()

    show: ->
        @storeFocusedElement()
        @panel ?= atom.workspace.addModalPanel(item: @element, visible: false)
        @panel.show()
        @inputVal = document.getElementById('enterVal')
        @storeFocusedElement()
        @inputVal.focus()
        @inputVal.value = ""

    hide: ->
        @panel?.hide()

    cancel: ->
        @panel.hide()

    storeFocusedElement: ->
        @previouslyFocusedElement = document.activeElement

    restoreFocus: ->
        @previouslyFocusedElement?.focus()

    insertNums: (start) ->
        editor = @editor.getBuffer()
        pos = @editor.getCursorBufferPositions()
        check = editor.createCheckpoint()
        startPoint = parseInt(start.split(":")[0])
        direction = parseInt(start.split(":")[1])

        pos.sort (a,b) ->
            if a.row > b.row
                return 1
            if a.row < b.row
                return -1
            return 0

        for x in pos
            editor.insert([x.row, x.column], String(startPoint))
            if direction == undefined || isNaN(direction)
                startPoint++
            else
                startPoint = startPoint + direction

        editor.groupChangesSinceCheckpoint(check)
        @restoreFocus()
