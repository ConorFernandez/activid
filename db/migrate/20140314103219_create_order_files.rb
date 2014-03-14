class CreateOrderFiles < ActiveRecord::Migration
  def change
    create_table :order_files do |t|
      t.string :original_filename
      t.string :uploaded_filename

      t.belongs_to :order, null: false
      t.timestamps
    end
  end
end
