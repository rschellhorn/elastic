handler = (event) ->

    fragment = $(event.fragment)
    slide = fragment.parents('section')

    if fragment.data('activate')
        $('.active', slide).removeClass('active')
        $($('.fragment.visible:last', slide).data('activate'), quote).addClass('active')
        fragment.addClass('active')

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

        when "lom"
            slide.removeClass('second')
            if fragment.hasClass('json') and event.type is 'fragmentshown'
                slide.addClass('second')

        when "search"
            $.ajax
                url: $('body').data('url') + '/edurep/lom/_search'
                type: 'POST'
                data: fragment.prev('pre').text()
                success: (data) ->
                    $('code', fragment).html( highlight(data) )

Reveal.addEventListener 'fragmentshown', handler
Reveal.addEventListener 'fragmenthidden', handler