class StripeAccount < ApplicationRecord
  belongs_to :user
  has_one_attached :identity_document
  has_one_attached :verify_home_address
  validates :first_name,
            presence: true, length: { minimum: 1, maximum: 40 }

  validates :last_name,
            presence: true, length: { minimum: 1, maximum: 40 }

  validates :account_type,
            presence: true, inclusion: { in: %w(individual company), message: "%{value} is not a valid account type"}

  validates :tos,
            inclusion: { in: [ true ], message: ": You must agree to the terms of service" }

  def identity_document_path
    ActiveStorage::Blob.service.path_for(identity_document.key)
  end
end
