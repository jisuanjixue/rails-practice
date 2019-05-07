class User < ApplicationRecord
  has_many :groups, through: :memberships
  has_many :memberships, class_name: "membership", foreign_key: "reference_id"
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def display_name
    self.email.split("@").first
  end

end
