class Order < ActiveRecord::Base
  module Status
    DRAFT = 'DRAFT'
    PAID = 'PAID'
  end

  attr_accessor :preparing_for_payment
  has_many :order_files
  belongs_to :video_length
  belongs_to :coupon

  accepts_nested_attributes_for :order_files
  validates :secure_token, presence: true
  validates :status, presence: true
  validates :cardholder_email, presence: true, if: :preparing_for_payment?
  validates :video_length_id, presence: true, if: :preparing_for_payment?
  before_validation :generate_secure_token

  scope :paid, -> { where(status: Order::Status::PAID) }

  def paid?
    status == Status::PAID
  end

  def self.video_cost(video_length, coupon = nil)
    raise 'video_length cannot be nil!' unless video_length
    video_cost = video_length.cost * 100
    coupon_discount = coupon ? coupon.discount * 100 : 0
    final_cost = video_cost - coupon_discount
    final_cost = 0 if final_cost < 0
    Money.new final_cost
  end

  # Returns Order Cost as a Money object.
  def order_cost
    Order.video_cost(video_length, coupon)
  end

  protected

  def generate_secure_token
    self.secure_token ||= SecureRandom.hex
  end

  def preparing_for_payment?
    preparing_for_payment
  end
end
