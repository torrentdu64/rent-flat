class StripeIdentityVerificationSessionRequiresInput
  def call(event)
    p "webhook status verification"
    p event

    client = Stripe::Identity::VerificationSession.retrieve(
      event.data.object.client_secret,
      )
    
    p client
  end
end