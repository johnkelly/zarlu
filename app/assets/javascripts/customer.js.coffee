subscription =
  setupForm: ->
    $('form.edit_subscriber').submit ->
      $('input[type=submit]').prop('disabled', true)
      if $('#card_number').length
        subscription.processCard()
        false
      else
        true

  processCard: ->
    card =
      number: $.trim($('#card_number').val())
      cvc: $.trim($('#card_code').val())
      expMonth: $('#card_month').val()
      expYear: $('#card_year').val()

    Stripe.createToken(card, subscription.handleStripeResponse)

  handleStripeResponse: (status, response) ->
    if status == 200
      $('#subscriber_card_token').val(response.id)
      $('form.edit_subscriber')[0].submit()
      track_add_credit_card()
    else
      $('#stripe_error').removeClass('hide')
      $('#stripe_error').text(response.error.message)
      $('input[type=submit]').prop('disabled', false)

jQuery ->
  if $('.subscriptions_show').length || $('.subscriptions_create').length
    Stripe.setPublishableKey($('meta[data-name="stripe-key"]').attr('data-value'))
    subscription.setupForm()

track_add_credit_card = ->
  if $('.subscriptions_show').length
    form = $('.edit_subscriber')
    analytics.track('Add / Update Credit Card', {})
