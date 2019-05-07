class Group < ApplicationRecord
  has_many :users, through: :memberships
  has_many :memberships, class_name: "membership", foreign_key: "reference_id"
end
