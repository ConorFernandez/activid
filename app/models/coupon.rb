class Coupon < ActiveRecord::Base
  scope :enabled, -> { where(enabled: true) }
end
