module ApplicationHelper

  def stripe_connect_url
    "https://connect.stripe.com/oauth/authorize?response_type=code&client_id=#{ENV["STRIPE_CONNECT_CLIENT_ID"]}&scope=read_write"
  end

  def stripe_button_connect_wallet
    link_to stripe_connect_url , class: "btn-stripe-connect"  do
      content_tag :span, "connect wallet"
    end
  end


end
