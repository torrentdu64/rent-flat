class OrdersController < ApplicationController

  def create
    flat = Flat.find(params[:flat_id])
    order  = Order.create!(flat: flat, flat_sku: flat.title, amount: flat.price, state: 'pending', user: current_user)

    checkout_session = Stripe::Checkout::Session.create(
      success_url: order_url(order) + "?session_id={CHECKOUT_SESSION_ID}",
      cancel_url: order_url(order),
      customer: current_user.stripe_customer_id,
      mode: 'payment',
      line_items: [{
        price_data: {
          unit_amount: flat.price_cents,
          currency: 'nzd',
          product: flat.stripe_product_id
        },
        quantity: 1,
      }],
      metadata: {
        order_id: order.id,
      },
      payment_intent_data: {
        metadata: {
          order_id: order.id,
        },
      }
    )


    order.update(checkout_session_id: checkout_session.id)
    redirect_to new_order_payment_path(order)
  end

  def rent
    # https://stripe.com/docs/connect/subscriptions
    @flat = Flat.find(params[:id])
    key = @flat.user.access_code
    Stripe.api_key = key

    #plan_id = @flat.plan_id
    # Stripe.api_key = key

    #plan_id = @flat.plan_id
    stripe_price =  Stripe::Price::retrieve(@flat.stripe_price_id)
    #plan = Stripe::Plan.retrieve(plan_id)
    token = params[:stripeToken]
    byebug
    # key = @flat.user.access_code
    # Stripe.api_key = key

    # customer = if current_user.stripe_customer_id?
    #             Stripe::Customer.retrieve(current_user.stripe_customer_id)
    #           else
    #             Stripe::Customer.create(email: current_user.email, source: token)
    #           end


    key = @flat.user.access_code
    Stripe.api_key = key

    tenant_customer = Stripe::Customer.create({
      email: current_user.email,
      source: token
    })

    current_user.update(stripe_customer_id: tenant_customer.id )



    order  = Order.create!(flat: @flat, flat_sku: @flat.title, amount: @flat.price, state: 'pending', user: current_user)

    key = @flat.user.access_code
    Stripe.api_key = key
    subscription = Stripe::Subscription.create({
      customer: tenant_customer,
      items: [
        {
          price: @flat.stripe_price_id,  quantity: 1

        }
      ],
      expand: ["latest_invoice.payment_intent", "plan.product"],
    })


    options = {
      stripe_id: tenant_customer.id,
      subscribed: true,
    }

    options.merge!(
      card_last4: params[:user][:card_last4],
      card_exp_month: params[:user][:card_exp_month],
      card_exp_year: params[:user][:card_exp_year],
      card_type: params[:user][:card_brand]
    )

   # current_user.perk_subscriptions << plan_id
    current_user.update(options)

    # Update project attributes
    # project_updates = {
    #   backings_count: @project.backings_count.next,
    #   current_donation_amount: @project.current_donation_amount + (plan.amount/100).to_i,
    # }
    # @flat.update(project_updates)


    redirect_to root_path, notice: "Your subscription was setup successfully!"
  end

  def unsubscribe
    subscription_to_remove = params[:id]
    plan_to_remove = params[:plan_id]
    customer = Stripe::Customer.retrieve(current_user.stripe_id)
    customer.subscriptions.retrieve(subscription_to_remove).delete
    current_user.subscribed = false
    current_user.perk_subscriptions.delete(plan_to_remove)
    current_user.save
    redirect_to root_path, notice: "Your subscription has been cancelled."
  end


  def success_checkout
    #build view nd logic
  end

  def faile_checkout
    #build view nd logic
  end

  def show
    @order = current_user.orders.find(params[:id])
  end

  def cancel
    @order = current_user.orders.find(params[:id])
    refund = Stripe::Refund.create({
      payment_intent: @order.stripe_payment_intent_id
    })
    @orde.update(stripe_refund_id: refund.id)
  end
end
