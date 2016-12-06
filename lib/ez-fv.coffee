EzFvView = require './views/ez-fv-view'
Questions = require './views/questions'
InsertNumbersView = require './views/insert-numbers-view'

{CompositeDisposable} = require 'atom'

module.exports = EzFv =
    ezFvView: null
    questions: null
    subscriptions: null

    activate: (state) ->
        @ezFvView = new EzFvView(state.ezFvViewState)
        @InsertNumbersView = new InsertNumbersView(state.insertNumbersView)
        @questions = new Questions(state.questions)
        @subscriptions = new CompositeDisposable
        # @subscriptions.add
        atom.commands.add('atom-workspace', 'ez-fv:insert': => @insert())
        atom.commands.add('atom-workspace', 'ez-fv:rows': => @rows())
        atom.commands.add('atom-workspace', 'ez-fv:cols': => @cols())
        atom.commands.add('atom-workspace', 'ez-fv:choices': => @choices())
        atom.commands.add('atom-workspace', 'ez-fv:cases': => @cases())
        atom.commands.add('atom-workspace', 'ez-fv:strip': => @strip())
        atom.commands.add('atom-workspace', 'ez-fv:radio': => @radio())
        atom.commands.add('atom-workspace', 'ez-fv:checkbox': => @checkbox())
        atom.commands.add('atom-workspace', 'ez-fv:select': => @select())
        atom.commands.add('atom-workspace', 'ez-fv:number': => @number())
        atom.commands.add('atom-workspace', 'ez-fv:float': => @float())
        atom.commands.add('atom-workspace', 'ez-fv:text': => @text())
        atom.commands.add('atom-workspace', 'ez-fv:textarea': => @textarea())
        atom.commands.add('atom-workspace', 'ez-fv:comment': => @comment())

    deactivate: ->
        @subscriptions.dispose()
        @ezFvView.destroy()
        @questions.destroy()

    serialize: ->
        ezFvViewState: @ezFvView.serialize()
        questionsState: @questions.serialize()

    insert: ->
        if editor = atom.workspace.getActiveTextEditor()
            # @modalPanel = atom.workspace.addModalPanel(item: @InsertNumbersView.getElement(), visible: false)
            @InsertNumbersView.toggle(editor)

    comment: ->
        @ezFvView.comment()

    rows: ->
        @ezFvView.rows()

    cols: ->
        @ezFvView.cols()

    choices: ->
        @ezFvView.choices()

    cases: ->
        @ezFvView.cases()

    strip: ->
        @ezFvView.strip()

    radio:->
        @questions.radio()

    checkbox:->
        @questions.checkbox()

    select:->
        @questions.select()

    number:->
        @questions.number()

    float:->
        @questions.float()

    text:->
        @questions.text()

    textarea:->
        @questions.textarea()
