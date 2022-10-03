class CreateDonations < ActiveRecord::Migration[6.1]
  def change
    create_table :donations do |t|

      t.belongs_to :campaign, foreign_key: true, null: false
      t.belongs_to :donor, foreign_key: true, null: false

      t.decimal :amount, precision: 8, scale: 2
      t.integer :kind, null: false, default: 0

      t.decimal :match_max_amount, precision: 8, scale: 2
      t.decimal :match_amount, precision: 8, scale: 2

      t.timestamps
    end
  end
end
