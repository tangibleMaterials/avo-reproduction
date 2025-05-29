class User < ApplicationRecord
  has_many :requirements
  has_many :user_organizations
  has_many :organizations, through: :user_organizations

  accepts_nested_attributes_for :requirements, allow_destroy: true
  accepts_nested_attributes_for :user_organizations, allow_destroy: true
end
