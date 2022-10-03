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
class Donor < ApplicationRecord

  has_many :donations

  validates :email, presence: true
  validates :first_name, presence: true
  validates :last_name, presence: true

  def name
    [
      first_name,
      last_name
    ].reject(&:empty?).join(' ')
  end

end
