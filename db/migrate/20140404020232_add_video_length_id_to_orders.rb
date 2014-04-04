class AddVideoLengthIdToOrders < ActiveRecord::Migration
  def change
    change_table :orders do |t|
      t.remove :video_length
      t.belongs_to :video_length
    end
  end
end
