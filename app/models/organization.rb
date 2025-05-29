class Organization < ApplicationRecord
  has_many :user_organizations
  has_many :users, through: :user_organizations

  accepts_nested_attributes_for :user_organizations, allow_destroy: true
end
