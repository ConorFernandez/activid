class Order < ActiveRecord::Base
  module Status
    DRAFT = 'DRAFT'
  end

  has_many :order_files

  accepts_nested_attributes_for :order_files
  validates :secure_token, presence: true
  validates :status, presence: true

  before_validation :generate_secure_token

  protected

  def generate_secure_token
    self.secure_token ||= SecureRandom.hex
  end
end
