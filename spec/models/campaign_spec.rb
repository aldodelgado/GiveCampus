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
require 'rails_helper'

RSpec.describe Campaign, type: :model do

  describe "database schema" do
    it { should have_db_column(:id).of_type(:integer) }
    it { should have_db_column(:name).of_type(:string) }
    it { should have_db_column(:goal_amount).of_type(:decimal) }
    it { should have_db_column(:start_date).of_type(:date) }
    it { should have_db_column(:end_date).of_type(:date) }
  end

  describe "association" do
    it { should have_many(:donations) }
    it { should have_many(:donors).through(:donations) }
  end

  describe "validation" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:start_date) }
    it { should validate_presence_of(:end_date) }

  end
end
