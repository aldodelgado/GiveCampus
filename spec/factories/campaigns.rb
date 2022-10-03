# == Schema Information
#
# Table name: campaigns
#
#  id          :integer          not null, primary key
#  end_date    :date
#  goal_amount :decimal(8, 2)
#  name        :string           not null
#  start_date  :date
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
FactoryBot.define do
  factory :campaign do
    name          { "Test Campaign - #{DateTime.now}" }
    start_date    { Date.today }
    end_date      { start_date + 1.week }
    goal_amount   { 1000.00}
  end
end
