class AddCouponIdToOrder < ActiveRecord::Migration
  def change
    change_table :orders do |t|
      t.belongs_to :coupon
    end
  end
end
