infinite_activity_feed = ->
  if $('.pagination').length
    $(window).scroll ->
      url = $('.pagination .next_page').attr('href')
      if url && $(window).scrollTop() > $(document).height() - $(window).height() - 50
        $('.pagination').text('Fetching more events...')
        $.getScript(url)

jQuery ->
  infinite_activity_feed()
