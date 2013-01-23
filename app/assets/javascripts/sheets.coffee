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

    $('#indexing-lom button').click (event) ->
        block = $(this).parents('pre')
        $.ajax
            url: $('body').data('url') + '/edurep/lom'
            type: 'POST'
            data: $('code.data', block).text()
            success: (data) ->
                $('code.result', block).html( highlight(data) ).addClass('visible')
                $('#get span.lomId').html(data._id)
                $('#delete span.lomId').html(data._id)

    $('#get button').click (event) ->
        block = $(this).parents('pre')
        $.ajax
            url: $('body').data('url') + '/edurep/lom/' + $('span.lomId', block).text()
            success: (data) ->
                $('code.result', block).html( highlight(data) ).addClass('visible')

    $('#delete button').click (event) ->
        block = $(this).parents('pre')
        $.ajax
            url: $('body').data('url') + '/edurep/lom/' + $('span.lomId', block).text()
            type: 'DELETE'
            success: (data) ->
                $('code.result', block).html( highlight(data) ).addClass('visible')

    $('#put-mapping button.put').click (event) ->
        block = $(this).parents('pre')
        $.ajax
            url: $('body').data('url') + '/edurep2'
            type: 'POST'
            data: $('code.data', block).text()
            success: (data) ->
                $('code.result', block).html( highlight(data) ).addClass('visible')

    $('#put-mapping2 button.put').click (event) ->
        block = $(this).parents('pre')
        $.ajax
            url: $('body').data('url') + '/edurep3'
            type: 'POST'
            data: $('code.data', block).text()
            success: (data) ->
                $('code.result', block).html( highlight(data) ).addClass('visible')

    $('#reindex button').click (event) ->
        block = $(this).parents('pre')
        $.ajax
            url: $(this).data('url')
            type: 'POST'
            beforeSend: ->
                $('code.result', block).addClass('visible')
            success: (data) ->
                $('code.result', block).html(data)

    $('#reindex2 button.reindex').click (event) ->
        block = $(this).parents('pre')
        $.ajax
            url: $(this).data('url')
            type: 'POST'
            beforeSend: ->
                $('code.result', block).addClass('visible')
            success: (data) ->
                $('code.result', block).html(data)

    $('#reindex2  button.alias').click (event) ->
        pre = $(this).parents('pre')
        $.ajax
            url: $('body').data('url') + '/_aliases'
            type: 'POST'
            data: $('code.data', pre).text()
            success: (data) ->
                $('code.result', pre).html( highlight(data) ).addClass('visible')

    $('#alias button.delete').click (event) ->
        block = $(this).parents('pre')
        $.ajax
            url: $('body').data('url') + '/edurep'
            type: 'DELETE'
            success: (data) ->
                $('code.result', block).html( highlight(data) ).addClass('visible')

    $('#alias button.alias').click (event) ->
        pre = $(this).parents('pre')
        $.ajax
            url: $('body').data('url') + '/_aliases'
            type: 'POST'
            data: $('code.data', pre).text()
            success: (data) ->
                $('code.result', pre).html( highlight(data) ).addClass('visible')

    $('#put-mapping3 button.put').click (event) ->
        block = $(this).parents('pre')
        $.ajax
            url: $('body').data('url') + '/edurep4'
            type: 'POST'
            data: $('code.data', block).text()
            success: (data) ->
                $('code.result', block).html( highlight(data) ).addClass('visible')

    $('#reindex3 button.reindex').click (event) ->
        block = $(this).parents('pre')
        $.ajax
            url: $(this).data('url')
            type: 'POST'
            beforeSend: ->
                $('code.result', block).addClass('visible')
            success: (data) ->
                $('code.result', block).html(data)

    $('#reindex3  button.alias').click (event) ->
        pre = $(this).parents('pre')
        $.ajax
            url: $('body').data('url') + '/_aliases'
            type: 'POST'
            data: $('code.data', pre).text()
            success: (data) ->
                $('code.result', pre).html( highlight(data) ).addClass('visible')

    $('section.scripts button.get').click ->
        block = $(this).parents('pre')
        $.ajax
            url: $(this).data('url')
            success: (data) ->
                $('code.result', block).html( highlight(data) ).addClass('visible')

    $('#put-mapping4 button.put').click (event) ->
        block = $(this).parents('pre')
        $.ajax
            url: $('body').data('url') + '/edurep5'
            type: 'POST'
            data: $('code.data', block).text()
            success: (data) ->
                $('code.result', block).html( highlight(data) ).addClass('visible')

    $('#reindex4 button.reindex').click (event) ->
        block = $(this).parents('pre')
        $.ajax
            url: $(this).data('url')
            type: 'POST'
            beforeSend: ->
                $('code.result', block).addClass('visible')
            success: (data) ->
                $('code.result', block).html(data)

    $('#reindex4  button.alias').click (event) ->
        pre = $(this).parents('pre')
        $.ajax
            url: $('body').data('url') + '/_aliases'
            type: 'POST'
            data: $('code.data', pre).text()
            success: (data) ->
                $('code.result', pre).html( highlight(data) ).addClass('visible')

    $('#autocomplete-example input').keyup ->
        block = $(this).parents('section')
        text = $(this).val()
        if (text and text.length > 1)
            $.ajax
                url: $('body').data('url') + '/edurep/lom/_search'
                type: 'POST'
                data: """{
  "query": {
    "match": {
      "title.autocomplete": "#{text}"
    }
  },
  "fields": [],
  "highlight": {
    "fields" : {
      "title.autocomplete" : {}
    }
  }
}"""
                success: (data) ->
                    suggestions = $('ol.suggestions', block).empty().addClass('visible')
                    $('ol.suggestions', block).empty().removeClass('visible') if data.hits.hits.length == 0
                    $(data.hits.hits).each ->
                        $('<li>').html(this.highlight['title.autocomplete'][0]).appendTo(suggestions)
        else
            $('ol.suggestions', block).empty().removeClass('visible')

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
            error: (xhr) ->
                $('code', fragment).text( JSON.parse(xhr.responseText).error )

    handler(event)

Reveal.addEventListener 'fragmenthidden', (event) ->
    fragment = $(event.fragment)
    slide = fragment.parents('section')
    state = fragment.data('state')
    slide.removeClass(state) if state
    handler(event)