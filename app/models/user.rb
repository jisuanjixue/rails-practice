class User < ApplicationRecord
  has_many :memberships
  has_many :groups, through: :memberships
  has_one :profile
  has_many :registrations
  # 可以在更新 User 时，也顺便可以更新 Profile 资料
  accepts_nested_attributes_for :profile
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  ROLES = ["admin", "editor"]

  def display_name
    email.split('@').first
  end

  def is_admin?
    self.role == "admin"
  end

  def is_editor?
    ["admin", "editor"].include?(self.role)
  end
end
