class CreateCampaigns < ActiveRecord::Migration[6.1]
  def change
    create_table :campaigns do |t|
      t.string :name, null: false
      t.decimal :goal_amount, precision: 8, scale: 2
      t.date :start_date
      t.date :end_date

      t.timestamps
    end
  end
end
