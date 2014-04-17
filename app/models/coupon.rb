class Coupon < ActiveRecord::Base
  scope :enabled, -> { where(enabled: true) }

  def is_usable?
    return true if use_count.blank?
    Order.paid.where(coupon_id: id).count < use_count
  end
end
