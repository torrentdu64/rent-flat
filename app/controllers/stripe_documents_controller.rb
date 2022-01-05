class StripeDocumentsController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :verify_authenticity_token

  def identity_document

    @account = StripeAccount.find(params[:id])


    if @account.update(documents_params)
      redirect_to dashboards_stripe_account_path(@account) and return
    else
      raise
    end

  end

  def address_document
    @stripe_account = current_user.stripe_accounts.first
  end





  def create

  #   content_type = "application/json"
  #
  #   verification_session = Stripe::Identity::VerificationSession.create(
  # {
  #       type: 'document',
  #       metadata: {
  #         user_id: current_user.id,
  #       },
  #     }
  #   )
  #

  #   # Return only the client secret to the frontend
  #   render json: { client_secret: verification_session.client_secret }.to_h


  stripe_account = Stripe::Account.retrieve(current_user.uid)
  stripe_info =  stripe_account.to_h
  person_id = stripe_info[:individual][:id]

  upload_stripe_document =  Stripe::File.create(
{
          file: File.new(File.join('public', 'uploads', 'android-chrome-256x256.png')),
          purpose: 'identity_document',
        },
{:stripe_account => current_user.uid}
  )

  if params[:stripe_account][:identity_document].present?

    document_uploded =  Stripe::Account.update_person(
      current_user.uid,
      person_id,
      {
        metadata: { info: 'info about object'},
        verification: {document: {front: upload_stripe_document.id }},
      })
  end

  if params[:stripe_account][:verify_home_address].present?

    address_document_uploded =  Stripe::Account.update_person(
      current_user.uid,
      person_id,
      {
        metadata: { info: 'info about object'},
        verification: {additional_document: {front: upload_stripe_document.id }},
      })
  end
  @account = StripeAccount.find(params[:account_id])
  redirect_to dashboards_stripe_account_path(@account, @stripe_account) and return

  end

  def admin_upload_document
      content_type = "application/json"

      verification_session = Stripe::Identity::VerificationSession.create(
    {
          type: 'document',
          metadata: {
            user_id: params[:user_id],
          },
        }
      )





      # Return only the client secret to the frontend
      render json: {client_secret: verification_session.client_secret }.to_json
  end

  private

  def documents_params
   params.require(:stripe_account).permit(:identity_document, :verify_home_address)
  end

end
