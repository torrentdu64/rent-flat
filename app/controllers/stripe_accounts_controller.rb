class StripeAccountsController < ApplicationController
  before_action :authenticate_user!

  def new
    @account = StripeAccount.new
  end

  def verification
    @stripe_account_pending = StripeAccount.where(charges_enabled: false)
    @stripe_account_verify = StripeAccount.where(charges_enabled: true)
    #
    # do for reject
  end

  def create
    byebug
    @account = StripeAccount.new(account_params)
    @account.user_id = current_user.id

    if @account.save
      begin
        # There are different requirements for individuals vs companies
        # Using separate request for each in this example

        # If this is an individual, send request params to create an individual acct
        if account_params[:account_type].eql?('individual')

          stripe_account = Stripe::Account.create(
            type: 'custom',
            # requested_capabilities: ['platform_payments'], # Donors interact with the platform
            capabilities: {
              card_payments: {requested: true},
              transfers: {requested: true},
            },
            business_type: 'individual',
            individual: {
              first_name: account_params[:first_name].capitalize,
              last_name: account_params[:last_name].capitalize,
              dob: {
                day: account_params[:dob_day],
                month: account_params[:dob_month],
                year: account_params[:dob_year],
              },
              email: current_user.email,
              phone: "+642041845759",
              address: {
                city: "Auckland",
                country: "NZ",
                line1: "4 glasgow, terrace",
                line2: "",
                postal_code: "1023",
                state: "grafton"
              }
              #ssn_last_4: account_params[:ssn_last_4],
            },
            business_profile: {
              product_description: 'Fundraising campaign',
            },
            tos_acceptance: {
              date: Time.now.to_i,
              ip: request.remote_ip
            }
          )

          # If the account type is a company, send company information
        else
          stripe_account = Stripe::Account.create(
            type: 'custom',
            # requested_capabilities: ['platform_payments'], # Donors interact with the platform
            capabilities: {
              card_payments: {requested: true},
              transfers: {requested: true},
            },
            business_type: 'company',
            company: {
              name: account_params[:business_name],
              tax_id: account_params[:business_tax_id],
            },
            business_profile: {
              product_description: 'Fundraising campaign',
            },
            tos_acceptance: {
              date: Time.now.to_i,
              ip: request.remote_ip
            }
          )
        end

        # Save the account ID for this user for later
        @account.acct_id = stripe_account.id
        @account.save
        current_user.uid = stripe_account.id

        if current_user.save
          flash[:success] = "Your account has been created!
            Next, add a bank account where you'd like to receive transfers below."
          redirect_to new_bank_account_path
        else
          handle_error("Sorry, we weren't able to create this account.", 'new')
        end

        # Handle exceptions from Stripe
      rescue Stripe::StripeError => e
        handle_error(e.message, 'new')

        # Handle any other exceptions
      rescue => e
        handle_error(e.message, 'new')
      end
    else
      @full_account = true if params[:full_account]
      handle_error(@account.errors.full_messages)
    end
  end

  def edit

    # Retrieve the local account details
    @account = StripeAccount.find(params[:id])
    # Check for a valid account ID
    unless  !@account.charges_enabled
      flash[:notice] = "No Stripe account specified"
      redirect_to root_path and return
    end

    # Retrieve the Stripe account to find fields needed
    @stripe_account = Stripe::Account.retrieve(@account.acct_id)

    # Retrieve the local account details
    #  @account = StripeAccount.find_by(acct_id: params[:id])

    if @stripe_account.requirements.currently_due.empty?
      flash[:notice] = "Your information is all up to date."
      redirect_to dashboards_path and return
    end
  end

  def update
    # Check for an existing Stripe account
    unless current_user.uid
      redirect_to new_stripe_account_path and return
    end

    begin
      # Retrieve the Stripe account
      @stripe_account = Stripe::Account.retrieve(current_user.uid)

      @account = StripeAccount.new(account_params)


      # Reject empty values
      account_params.each do |key, value|
        if value.empty?
          flash.now[:alert] = "Please complete all fields."
          render 'edit' and return
        end
      end

      # Iterate through each field needed
      @stripe_account.requirements.eventually_due.each do |field|

        # Update each needed attribute
        case field
        when 'individual.address.city'
          @stripe_account.individual.address.city = account_params[:address_city]
        when 'individual.address.line1'
          @stripe_account.individual.address.line1 = account_params[:address_line1]
        when 'individual.address.postal_code'
          @stripe_account.individual.address.postal_code = account_params[:address_postal]
        when 'individual.address.state'
          @stripe_account.individual.address.state = account_params[:address_state]
        when 'individual.dob.day'
          @stripe_account.individual.dob.day = account_params[:dob_day]
        when 'individual.dob.month'
          @stripe_account.individual.dob.month = account_params[:dob_month]
        when 'individual.dob.year'
          @stripe_account.individual.dob.year = account_params[:dob_year]
        when 'individual.first_name'
          @stripe_account.individual.first_name = account_params[:first_name]
        when 'individual.last_name'
          @stripe_account.individual.last_name = account_params[:last_name]
        when 'individual.ssn_last_4'
          @stripe_account.individual.ssn_last_4 = account_params[:ssn_last_4]
        when 'business_type'
          @stripe_account.business_type = account_params[:type]
        when 'individual.id_number'
          @stripe_account.individual.id_number = account_params[:personal_id_number]
        when 'individual.verification.document'
          @stripe_account.individual.verification.document.front = account_params[:verification_document]
        when 'company.name'
          @stripe_account.company.name = account_params[:business_name]
        when 'company.tax_id'
          @stripe_account.company.tax_id = account_params[:business_tax_id]
        end
      end

      @stripe_account.save
      flash[:success] = "Thanks! Your account has been updated."
      redirect_to dashboard_path and return

      # Handle exceptions from Stripe
    rescue Stripe::StripeError => e
      handle_error(e.message, 'edit')

      # Handle any other exceptions
    rescue => e
      handle_error(e.message, 'edit')
    end
  end


  def show
    @account = StripeAccount.find(params[:id])
  end

  private
  def account_params
    params.require(:stripe_account).permit(
      :first_name, :last_name, :account_type, :dob_month, :dob_day, :dob_year, :tos,
      :ssn_last_4, :address_line1, :address_city, :address_state, :address_postal, :business_name,
      :business_tax_id, :full_account, :personal_id_number, :verification_document
    )
  end
end
