class Order < ActiveRecord::Base
  module Status
    DRAFT = 'DRAFT'
  end

  attr_accessor :preparing_for_payment
  has_many :order_files

  accepts_nested_attributes_for :order_files
  validates :secure_token, presence: true
  validates :status, presence: true
  validates :cardholder_email, presence: true, if: :preparing_for_payment?

  before_validation :generate_secure_token

  protected

  def generate_secure_token
    self.secure_token ||= SecureRandom.hex
  end

  def preparing_for_payment?
    preparing_for_payment == true
  end
end
