class CreateCreditCards < ActiveRecord::Migration
  def change
    create_table :credit_cards do |t|
      t.integer :user_id
      t.string :card_type
      t.string :card_number
      t.string :cardholder_name
      t.integer :expiration_month, :default => 1
      t.integer :expiration_year
      t.timestamps
    end
  end
end
