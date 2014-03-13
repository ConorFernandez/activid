class Order < ActiveRecord::Base
  validates :secure_token, presence: true

  before_validation :generate_secure_token

  protected

  def generate_secure_token
    self.secure_token ||= SecureRandom.hex
  end
end
