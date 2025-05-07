class Requirement < ApplicationRecord
  belongs_to :user

  serialize :values, coder: JSON
end
