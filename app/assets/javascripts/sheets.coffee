$ ->

    $('code.highlight').each ->
        $(this).html( highlight(JSON.parse($(this).text())) )

    $('pre code').focusout (event) ->
        $(this).html( highlight(JSON.parse($(this).text())) )

    $('#indexing button').click (event) ->
        block = $(this).parents('pre')
        $.ajax
            url: $(this).data('url')
            type: 'POST'
            beforeSend: ->
                $('code.result', block).addClass('visible')
            success: (data) ->
                $('code.result', block).html(data)

    $('#mapping button').click (event) ->
        block = $(this).parents('pre')
        $.ajax
            url: $('body').data('url') + '/edurep/lom/_mapping'
            success: (data) ->
                $('code.result', block).html( highlight(data) ).addClass('visible')

    $('#indexing-lom button').click (event) ->
        block = $(this).parents('pre')
        $.ajax
            url: $('body').data('url') + '/edurep/lom'
            type: 'POST'
            data: $('code.data', block).text()
            success: (data) ->
                $('code.result', block).html( highlight(data) ).addClass('visible')
                $('#get span.lomId').html(data._id)

    $('#get button').click (event) ->
        block = $(this).parents('pre')
        $.ajax
            url: $('body').data('url') + '/edurep/lom/' + $('span.lomId', block).text()
            success: (data) ->
                $('code.result', block).html( highlight(data) ).addClass('visible')

    $('#put-mapping button.put').click (event) ->
        block = $(this).parents('pre')
        $.ajax
            url: $('body').data('url') + '/edurep2'
            type: 'POST'
            data: $('code.data', block).text()
            success: (data) ->
                $('code.result', block).html( highlight(data) )

    $('#put-mapping button.reindex').click (event) ->
        $.ajax
            url: $(this).data('url')
            type: 'POST'

    $('#alias button.delete').click (event) ->
        slide = $(this).parents('section')
        $.ajax
            url: $('body').data('url') + '/edurep'
            type: 'DELETE'
            success: (data) ->
                $('code.result', slide).html( highlight(data) )

    $('#alias button.alias').click (event) ->
        pre = $(this).parents('pre')
        $.ajax
            url: $('body').data('url') + '/_aliases'
            type: 'POST'
            data: $('code.data', pre).text()
            success: (data) ->
                $('code.result', pre).html( highlight(data) )

handler = (event) ->

    fragment = $(event.fragment)
    slide = fragment.parents('section')

    if slide.hasClass('bullets')
        $('.fragment.visible', slide).addClass('other')
        $('.fragment.visible:last', slide).removeClass('other')

        if fragment.data('activate')
            $('.active', slide).removeClass('active')
            selector = $('.fragment.visible:last', slide).data('activate')
            $(selector, quote).addClass('active')

    switch slide.attr('id')

        when "full-text-search"
            quote = $('blockquote', slide)

            if fragment.hasClass('analyze') and event.type is 'fragmentshown'
                slide.addClass('full')
                $('.active', quote).removeClass('active')

                update = (analyzer) ->
                    $.ajax
                        url: $('body').data('url') + "/_analyze?analyzer=#{analyzer}"
                        type: 'POST'
                        data: quote.children('p').text()
                        success: (data) ->
                            $('code', fragment).html( highlight(data) )

                $('select', slide).change ->
                    update( $('select', slide).val() )
                update( $('select', slide).val() )
            else
                slide.removeClass('full')

Reveal.addEventListener 'fragmentshown', (event) ->
    fragment = $(event.fragment)
    state = fragment.data('state')

    # handle global state class
    slide = fragment.parents('section')
    slide.addClass(state) if state

    if slide.hasClass('search')
        $.ajax
            url: $('body').data('url') + '/edurep/lom/_search'
            type: 'POST'
            data: fragment.prev('pre').text()
            success: (data) ->
                $('code', fragment).html( highlight(data) )

    handler(event)

Reveal.addEventListener 'fragmenthidden', (event) ->
    fragment = $(event.fragment)
    slide = fragment.parents('section')
    state = fragment.data('state')
    slide.removeClass(state) if state
    handler(event)