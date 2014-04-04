class CreateVideoLengths < ActiveRecord::Migration
  def change
    create_table :video_lengths do |t|
      t.string :name, null: false
      t.decimal :cost, null: false
      t.boolean :enabled, default: false
      t.timestamps
    end
  end
end
