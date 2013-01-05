$ ->

    toCommand = (elem) ->
        data = $(elem).text()
        url = $(elem).data('url')
        method = 'GET'
        method = 'POST' if $(elem).hasClass('post')

        pretty = syntaxHighlight(data)
        $(elem).html("curl -X#{method} #{url} -d '\n#{pretty}\n'")

        $(elem).one 'click', ->
            $.ajax
                type: "#{method}"
                url: url
                data: data
                success: (data) ->
                    $('<pre>').addClass("response json").html(syntaxHighlight(data)).appendTo($(elem).parent()).slideDown('fast')

    $('#example').each (i, container) ->
        command = $("pre.command", container)
        data = command.text()
        url = command.data('url')

        addCurl = ->
            pretty = command.html()
            command.html("curl -XPOST #{url} -d '\n#{pretty}\n'")

        execute = ->
            $.ajax
                type: 'POST'
                url: url
                context: $(container)
                data: data
                success: (data) ->
                    $('<pre>').addClass("response json").html(syntaxHighlight(data)).appendTo(this).slideDown('fast')

        command.html(syntaxHighlight(data))
        command.one('click', (event) ->
            event.preventDefault()
            addCurl()
            command.one('click', ->
                execute()
            )
        )

    $('#mapping').one('click', ->
        $.ajax
            url: $('pre.query', this).data('url')
            context: $(this)
            success: (data) ->
                $('<pre>').addClass("response json").html(syntaxHighlight(data)).appendTo(this).slideDown('fast')
    )

    $('.elastic').each (i, elem) ->
        toCommand(elem)