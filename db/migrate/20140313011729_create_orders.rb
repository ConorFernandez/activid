class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.text :project_name
      t.hstore :files
      t.text :instructions
      t.string :video_length

      t.string :cardholder_name
      t.string :cardholder_address
      t.string :cardholder_city
      t.string :cardholder_state
      t.string :cardholder_zipcode
      t.string :cardholder_email
      t.string :cardholder_phone_number

      t.string :cc_last_four_no
      t.string :cc_exp_at

      t.string :status
      t.string :secure_token

      t.timestamps
    end
  end
end
