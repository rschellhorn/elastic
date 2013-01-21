$ ->

    $('#indexing button').click (event) ->
        slide = $(this).parents('section')
        code = $('code', slide).empty()

        socket = new WebSocket(slide.data('url'))

        socket.onopen = (event) ->
            socket.send('index')

        socket.onmessage = (event) ->
            current = code.text()
            code.text(event.data + '\n' + current)

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

        when "search"
            $.ajax
                url: $('body').data('url') + '/edurep/lom/_search'
                type: 'POST'
                data: fragment.prev('pre').text()
                success: (data) ->
                    $('code', fragment).html( highlight(data) )

        when "lom"
            $.ajax
                url: fragment.data('url')
                success: (data) ->
                    $('code', fragment).html( highlight(data) )

Reveal.addEventListener 'fragmentshown', (event) ->
    fragment = $(event.fragment)
    state = fragment.data('state')

    # handle global state class
    slide = fragment.parents('section')
    slide.addClass(state) if state

    handler(event)

Reveal.addEventListener 'fragmenthidden', (event) ->
    fragment = $(event.fragment)
    slide = fragment.parents('section')
    state = fragment.data('state')
    slide.removeClass(state) if state
    handler(event)

Reveal.addEventListener 'slidechanged', (event) ->
    slide = $(event.currentSlide)