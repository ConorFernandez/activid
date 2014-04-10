class CreateCoupons < ActiveRecord::Migration
  def change
    create_table :coupons do |t|
      t.string :name
      t.string :code
      t.decimal :discount
      t.boolean :enabled
      t.integer :use_count
      t.timestamps
    end
  end
end
