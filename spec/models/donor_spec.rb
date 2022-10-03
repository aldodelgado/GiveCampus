# == Schema Information
#
# Table name: donors
#
#  id         :integer          not null, primary key
#  email      :string           not null
#  first_name :string           not null
#  last_name  :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe Donor, type: :model do

	describe "database schema" do
		it { should have_db_column(:id).of_type(:integer) }
		it { should have_db_column(:first_name).of_type(:string) }
		it { should have_db_column(:last_name).of_type(:string) }
		it { should have_db_column(:email).of_type(:string) }
	end

	describe "association" do
		it { should have_many(:donations) }
	end

	describe "validation" do
		let(:donor) { build(:donor) }
		it { should validate_presence_of(:email) }
		it { should validate_presence_of(:first_name) }
		it { should validate_presence_of(:last_name) }
	end

end
