class Order < ActiveRecord::Base
  module Status
    DRAFT = 'DRAFT'
    PAID = 'PAID'
  end

  VIDEO_LENGTHS = ['2 Minutes', '4 Minutes']

  # Holds Order costs as decimal (9.99, 2.49, 5.15, etc)
  COSTS = {
      '2 Minutes' => 2.95,
      '4 Minutes' => 9.99
  }.freeze

  attr_accessor :preparing_for_payment
  has_many :order_files

  accepts_nested_attributes_for :order_files
  validates :secure_token, presence: true
  validates :status, presence: true
  validates :cardholder_email, presence: true, if: :preparing_for_payment?
  validates :video_length, inclusion: { in: VIDEO_LENGTHS }, if: :preparing_for_payment?
  before_validation :generate_secure_token

  def paid?
    status == Status::PAID
  end

  def self.video_cost(video_length)
    cost = COSTS[video_length]
    raise "Video Length is unexpected! (Got: #{video_length})" if cost.blank?
    Money.new(cost * 100, 'USD')
  end

  # Returns Order Cost as a Money object.
  def order_cost
    Order.video_cost(video_length)
  end

  protected

  def generate_secure_token
    self.secure_token ||= SecureRandom.hex
  end

  def preparing_for_payment?
    preparing_for_payment
  end
end
