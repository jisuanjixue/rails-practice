class Membership < ApplicationRecord
  belongs_to :user, class_name: "user", foreign_key: "user_id"
  belongs_to :group, class_name: "group", foreign_key: "group_id"
end
