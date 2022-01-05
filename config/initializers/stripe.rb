Rails.configuration.stripe = {
  publishable_key: ENV['STRIPE_PUBLISHABLE_KEY'],
  secret_key:      ENV['STRIPE_SECRET_KEY'],
  signing_secret:  ENV['STRIPE_WEBHOOK_SECRET_KEY']
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]
StripeEvent.signing_secret = Rails.configuration.stripe[:signing_secret]

StripeEvent.configure do |events|
  events.subscribe 'checkout.session.completed', StripeCheckoutSessionService.new
  events.subscribe 'charge.refunded', StripeChargeRefunded.new
  events.subscribe 'product.created', StripeProductCreated.new
  events.subscribe 'identity.verification_session.requires_input', StripeIdentityVerificationSessionRequiresInput.new
  # case events.type
  #   when 'account.updated'
  #       account = events.data.object
  #   when 'account.external_account.created'
  #       external_account = events.data.object
  #   when 'account.external_account.deleted'
  #       external_account = events.data.object
  #   when 'account.external_account.updated'
  #       external_account = events.data.object
  #   when 'balance.available'
  #       balance = events.data.object
  #   when 'billing_portal.configuration.created'
  #       configuration = events.data.object
  #   when 'billing_portal.configuration.updated'
  #       configuration = events.data.object
  #   when 'capability.updated'
  #       capability = events.data.object
  #   when 'charge.captured'
  #       charge = events.data.object
  #   when 'charge.expired'
  #       charge = events.data.object
  #   when 'charge.failed'
  #       charge = events.data.object
  #   when 'charge.pending'
  #       charge = events.data.object
  #   when 'charge.refunded'
  #       charge = events.data.object
  #   when 'charge.succeeded'
  #       charge = events.data.object
  #   when 'charge.updated'
  #       charge = events.data.object
  #   when 'charge.dispute.closed'
  #       dispute = events.data.object
  #   when 'charge.dispute.created'
  #       dispute = events.data.object
  #   when 'charge.dispute.funds_reinstated'
  #       dispute = events.data.object
  #   when 'charge.dispute.funds_withdrawn'
  #       dispute = events.data.object
  #   when 'charge.dispute.updated'
  #       dispute = events.data.object
  #   when 'charge.refund.updated'
  #       refund = events.data.object
  #   when 'checkout.session.async_payment_failed'
  #       session = events.data.object
  #   when 'checkout.session.async_payment_succeeded'
  #       session = events.data.object
  #   when 'checkout.session.completed'

  #   when 'checkout.session.expired'
  #       session = events.data.object
  #   when 'coupon.created'
  #       coupon = events.data.object
  #   when 'coupon.deleted'
  #       coupon = events.data.object
  #   when 'coupon.updated'
  #       coupon = events.data.object
  #   when 'credit_note.created'
  #       credit_note = events.data.object
  #   when 'credit_note.updated'
  #       credit_note = events.data.object
  #   when 'credit_note.voided'
  #       credit_note = events.data.object
  #   when 'customer.created'
  #       customer = events.data.object
  #   when 'customer.deleted'
  #       customer = events.data.object
  #   when 'customer.updated'
  #       customer = events.data.object
  #   when 'customer.discount.created'
  #       discount = events.data.object
  #   when 'customer.discount.deleted'
  #       discount = events.data.object
  #   when 'customer.discount.updated'
  #       discount = events.data.object
  #   when 'customer.source.created'
  #       source = events.data.object
  #   when 'customer.source.deleted'
  #       source = events.data.object
  #   when 'customer.source.expiring'
  #       source = events.data.object
  #   when 'customer.source.updated'
  #       source = events.data.object
  #   when 'customer.subscription.created'
  #       subscription = events.data.object
  #   when 'customer.subscription.deleted'
  #       subscription = events.data.object
  #   when 'customer.subscription.pending_update_applied'
  #       subscription = events.data.object
  #   when 'customer.subscription.pending_update_expired'
  #       subscription = events.data.object
  #   when 'customer.subscription.trial_will_end'
  #       subscription = events.data.object
  #   when 'customer.subscription.updated'
  #       subscription = events.data.object
  #   when 'customer.tax_id.created'
  #       tax_id = events.data.object
  #   when 'customer.tax_id.deleted'
  #       tax_id = events.data.object
  #   when 'customer.tax_id.updated'
  #       tax_id = events.data.object
  #   when 'file.created'
  #       file = events.data.object
  #   when 'identity.verification_session.canceled'
  #       verification_session = events.data.object
  #   when 'identity.verification_session.created'
  #       verification_session = events.data.object
  #   when 'identity.verification_session.processing'
  #       verification_session = events.data.object
  #   when 'identity.verification_session.redacted'
  #       verification_session = events.data.object
  #   when 'identity.verification_session.requires_input'
  #       verification_session = events.data.object
  #   when 'identity.verification_session.verified'
  #       verification_session = events.data.object
  #   when 'invoice.created'
  #       invoice = events.data.object
  #   when 'invoice.deleted'
  #       invoice = events.data.object
  #   when 'invoice.finalization_failed'
  #       invoice = events.data.object
  #   when 'invoice.finalized'
  #       invoice = events.data.object
  #   when 'invoice.marked_uncollectible'
  #       invoice = events.data.object
  #   when 'invoice.paid'
  #       invoice = events.data.object
  #   when 'invoice.payment_action_required'
  #       invoice = events.data.object
  #   when 'invoice.payment_failed'
  #       invoice = events.data.object
  #   when 'invoice.payment_succeeded'
  #       invoice = events.data.object
  #   when 'invoice.sent'
  #       invoice = events.data.object
  #   when 'invoice.upcoming'
  #       invoice = events.data.object
  #   when 'invoice.updated'
  #       invoice = events.data.object
  #   when 'invoice.voided'
  #       invoice = events.data.object
  #   when 'invoiceitem.created'
  #       invoiceitem = events.data.object
  #   when 'invoiceitem.deleted'
  #       invoiceitem = events.data.object
  #   when 'invoiceitem.updated'
  #       invoiceitem = events.data.object
  #   when 'issuing_authorization.created'
  #       issuing_authorization = events.data.object
  #   when 'issuing_authorization.request'
  #       issuing_authorization = events.data.object
  #   when 'issuing_authorization.updated'
  #       issuing_authorization = events.data.object
  #   when 'issuing_card.created'
  #       issuing_card = events.data.object
  #   when 'issuing_card.updated'
  #       issuing_card = events.data.object
  #   when 'issuing_cardholder.created'
  #       issuing_cardholder = events.data.object
  #   when 'issuing_cardholder.updated'
  #       issuing_cardholder = events.data.object
  #   when 'issuing_dispute.closed'
  #       issuing_dispute = events.data.object
  #   when 'issuing_dispute.created'
  #       issuing_dispute = events.data.object
  #   when 'issuing_dispute.funds_reinstated'
  #       issuing_dispute = events.data.object
  #   when 'issuing_dispute.submitted'
  #       issuing_dispute = events.data.object
  #   when 'issuing_dispute.updated'
  #       issuing_dispute = events.data.object
  #   when 'issuing_transaction.created'
  #       issuing_transaction = events.data.object
  #   when 'issuing_transaction.updated'
  #       issuing_transaction = events.data.object
  #   when 'mandate.updated'
  #       mandate = events.data.object
  #   when 'order.created'
  #       order = events.data.object
  #   when 'order.payment_failed'
  #       order = events.data.object
  #   when 'order.payment_succeeded'
  #       order = events.data.object
  #   when 'order.updated'
  #       order = events.data.object
  #   when 'order_return.created'
  #       order_return = events.data.object
  #   when 'payment_intent.amount_capturable_updated'
  #       payment_intent = events.data.object
  #   when 'payment_intent.canceled'
  #       payment_intent = events.data.object
  #   when 'payment_intent.created'
  #       payment_intent = events.data.object
  #   when 'payment_intent.payment_failed'
  #       payment_intent = events.data.object
  #   when 'payment_intent.processing'
  #       payment_intent = events.data.object
  #   when 'payment_intent.requires_action'
  #       payment_intent = events.data.object
  #   when 'payment_intent.succeeded'
  #       payment_intent = events.data.object
  #   when 'payment_method.attached'
  #       payment_method = events.data.object
  #   when 'payment_method.card_automatically_updated'
  #       payment_method = events.data.object
  #   when 'payment_method.detached'
  #       payment_method = events.data.object
  #   when 'payment_method.updated'
  #       payment_method = events.data.object
  #   when 'payout.canceled'
  #       payout = events.data.object
  #   when 'payout.created'
  #       payout = events.data.object
  #   when 'payout.failed'
  #       payout = events.data.object
  #   when 'payout.paid'
  #       payout = events.data.object
  #   when 'payout.updated'
  #       payout = events.data.object
  #   when 'person.created'
  #       person = events.data.object
  #   when 'person.deleted'
  #       person = events.data.object
  #   when 'person.updated'
  #       person = events.data.object
  #   when 'plan.created'
  #       plan = events.data.object
  #   when 'plan.deleted'
  #       plan = events.data.object
  #   when 'plan.updated'
  #       plan = events.data.object
  #   when 'price.created'
  #       price = events.data.object
  #   when 'price.deleted'
  #       price = events.data.object
  #   when 'price.updated'
  #       price = events.data.object
  #   when 'product.created'
  #       product = events.data.object
  #   when 'product.deleted'
  #       product = events.data.object
  #   when 'product.updated'
  #       product = events.data.object
  #   when 'promotion_code.created'
  #       promotion_code = events.data.object
  #   when 'promotion_code.updated'
  #       promotion_code = events.data.object
  #   when 'quote.accepted'
  #       quote = events.data.object
  #   when 'quote.canceled'
  #       quote = events.data.object
  #   when 'quote.created'
  #       quote = events.data.object
  #   when 'quote.finalized'
  #       quote = events.data.object
  #   when 'radar.early_fraud_warning.created'
  #       early_fraud_warning = events.data.object
  #   when 'radar.early_fraud_warning.updated'
  #       early_fraud_warning = events.data.object
  #   when 'recipient.created'
  #       recipient = events.data.object
  #   when 'recipient.deleted'
  #       recipient = events.data.object
  #   when 'recipient.updated'
  #       recipient = events.data.object
  #   when 'reporting.report_run.failed'
  #       report_run = events.data.object
  #   when 'reporting.report_run.succeeded'
  #       report_run = events.data.object
  #   when 'reporting.report_type.updated'
  #       report_type = events.data.object
  #   when 'review.closed'
  #       review = events.data.object
  #   when 'review.opened'
  #       review = events.data.object
  #   when 'setup_intent.canceled'
  #       setup_intent = events.data.object
  #   when 'setup_intent.created'
  #       setup_intent = events.data.object
  #   when 'setup_intent.requires_action'
  #       setup_intent = events.data.object
  #   when 'setup_intent.setup_failed'
  #       setup_intent = events.data.object
  #   when 'setup_intent.succeeded'
  #       setup_intent = events.data.object
  #   when 'sigma.scheduled_query_run.created'
  #       scheduled_query_run = events.data.object
  #   when 'sku.created'
  #       sku = events.data.object
  #   when 'sku.deleted'
  #       sku = events.data.object
  #   when 'sku.updated'
  #       sku = events.data.object
  #   when 'source.canceled'
  #       source = events.data.object
  #   when 'source.chargeable'
  #       source = events.data.object
  #   when 'source.failed'
  #       source = events.data.object
  #   when 'source.mandate_notification'
  #       source = events.data.object
  #   when 'source.refund_attributes_required'
  #       source = events.data.object
  #   when 'source.transaction.created'
  #       transaction = events.data.object
  #   when 'source.transaction.updated'
  #       transaction = events.data.object
  #   when 'subscription_schedule.aborted'
  #       subscription_schedule = events.data.object
  #   when 'subscription_schedule.canceled'
  #       subscription_schedule = events.data.object
  #   when 'subscription_schedule.completed'
  #       subscription_schedule = events.data.object
  #   when 'subscription_schedule.created'
  #       subscription_schedule = events.data.object
  #   when 'subscription_schedule.expiring'
  #       subscription_schedule = events.data.object
  #   when 'subscription_schedule.released'
  #       subscription_schedule = events.data.object
  #   when 'subscription_schedule.updated'
  #       subscription_schedule = events.data.object
  #   when 'tax_rate.created'
  #       tax_rate = events.data.object
  #   when 'tax_rate.updated'
  #       tax_rate = events.data.object
  #   when 'topup.canceled'
  #       topup = events.data.object
  #   when 'topup.created'
  #       topup = events.data.object
  #   when 'topup.failed'
  #       topup = events.data.object
  #   when 'topup.reversed'
  #       topup = events.data.object
  #   when 'topup.succeeded'
  #       topup = events.data.object
  #   when 'transfer.created'
  #       transfer = events.data.object
  #   when 'transfer.failed'
  #       transfer = events.data.object
  #   when 'transfer.paid'
  #       transfer = events.data.object
  #   when 'transfer.reversed'
  #       transfer = events.data.object
  #   when 'transfer.updated'
  #       transfer = events.data.object
  #   # ... handle other events types
  #   else
  #       puts "Unhandled events type: #{events.type}"

  # end
end

