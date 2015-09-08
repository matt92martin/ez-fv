module.exports =
class Questions
    serialize: ->

    destroy:->

    getEditor: ->
        @editor = atom.workspace.getActiveTextEditor()
        @selRange = @editor.getLastSelection().getBufferRange()
        @input = @editor.getTextInBufferRange(@selRange)

    getItems:->
        @input = @input.trim()

        label = @input.split(/^([a-zA-Z0-9-_]+)+(\.|:|\)|\s)/)[1]
        input = @input.split(/^([a-zA-Z0-9-_]+)+(\.|:|\)|\s)/).pop()

        input_array = []
        if input.indexOf('<row') != -1 then input_array.push(input.indexOf('<row'))
        if input.indexOf('<col') != -1 then input_array.push(input.indexOf('<col'))
        if input.indexOf('<choice') != -1 then input_array.push(input.indexOf('<choice'))
        if input.indexOf('<net') != -1 then input_array.push(input.indexOf('<net'))
        if input.indexOf('<group') != -1 then input_array.push(input.indexOf('<group'))
        if input.indexOf('<comment') != -1 then input_array.push(input.indexOf('<comment'))
        if input.indexOf('<exec') != -1 then input_array.push(input.indexOf('<exec'))
        if input.indexOf('<validate') != -1 then input_array.push(input.indexOf('<validate'))

        if input_array.length == 0
            title = input
        else
            min = Math.min.apply(null, input_array)
            title = input.substring(0,min)

        input = input.replace(title, "")
        input = input.replace(/\n{2,}/g, "\n")
        title = title.replace(/\n+$/g, "")
        title = title.trim()
        title = title.replace(/\n{2,}/g, "\n<br/><br/>\n")
        # title = title.slice(0, title.length-2)

        return [label, title, input]

    makeQuestion: (label, title, input, type, extra, comment="") ->
        question = """
                <#{type} label="#{label}"#{extra}>
                    <title>#{title}</title>
                    #{input}
                </#{type}>
                """
        return question

    insertQuestion: (question) ->
        @editor.setTextInBufferRange(@selRange, question,)

    radio:->
        @getEditor()
        label = @getItems()[0]
        title = @getItems()[1]
        input = @getItems()[2]

        rows = input.indexOf('<row')
        cols = input.indexOf('<col')
        if input.indexOf('<comment') == -1
            if rows != -1 && cols != -1
                comment = "\t<comment>Please select one from each row</comment>"
            else if rows != -1 || cols != -1
                comment = "\t<comment>Please select one</comment>"

        question = @makeQuestion(label, title, input, "radio", " optional=\"0\"", comment)
        @insertQuestion(question)

    checkbox:->
        @getEditor()
        label = @getItems()[0]
        title = @getItems()[1]
        input = @getItems()[2]

        if input.indexOf('<comment') == -1
            comment = "\t<comment>Please select all that apply</comment>"

        question = @makeQuestion(label, title, input, "checkbox", " atleast=\"1\"", comment)
        @insertQuestion(question)

    select:->
        @getEditor()
        label = @getItems()[0]
        title = @getItems()[1]
        input = @getItems()[2]

        rows = input.indexOf('<row')
        cols = input.indexOf('<col')
        if input.indexOf('<comment') == -1
            if rows != -1
                comment = "\t<comment>Please select one from each row</comment>"
            else if cols != -1
                comment = "\t<comment>Please select one from each column</comment>"
            else if rows == -1 && cols == -1
                comment = "\t<comment>Please select one</comment>"

        question = @makeQuestion(label, title, input, "select", " optional=\"0\"", comment)
        @insertQuestion(question)

    number:->
        @getEditor()
        label = @getItems()[0]
        title = @getItems()[1]
        input = @getItems()[2]

        if input.indexOf('<comment') == -1
            comment = "\t<comment>Please enter a whole number</comment>"

        question = @makeQuestion(label, title, input, "number", " optional=\"0\" size=\"3\"", comment)
        @insertQuestion(question)

    float:->
        @getEditor()
        label = @getItems()[0]
        title = @getItems()[1]
        input = @getItems()[2]

        if input.indexOf('<comment') == -1
            comment = "\t<comment>Please enter a number</comment>"

        question = @makeQuestion(label, title, input, "float", " optional=\"0\" size=\"3\"", comment)
        @insertQuestion(question)

    text:->
        @getEditor()
        label = @getItems()[0]
        title = @getItems()[1]
        input = @getItems()[2]

        if input.indexOf('<comment') == -1
            comment = "\t<comment>Please be as specific as possible</comment>"

        question = @makeQuestion(label, title, input, "text", " optional=\"0\" size=\"40\"", comment)
        @insertQuestion(question)

    textarea:->
        @getEditor()
        label = @getItems()[0]
        title = @getItems()[1]
        input = @getItems()[2]

        if input.indexOf('<comment') == -1
            comment = "\t<comment>Please be as specific as possible</comment>"

        question = @makeQuestion(label, title, input, "textarea", " optional=\"0\"", comment)
        @insertQuestion(question)

#Prototype declarations
String.prototype.trim = ->
    return String(this).replace(/^\s+|\s+$/g, '');
