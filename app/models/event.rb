class Event < ApplicationRecord

 validates_presence_of :name, :random_id
 validates_uniqueness_of :random_id, message: "必须不相同"
 validates_format_of :random_id, with: /\A[a-z0-9\-]+\z/, message: "无效的格式"

 before_validation :generate_random_id, on: :create

 # 在调用路由方法时，Rails 默认都会用 to_param 方法来转换 ID,
#  def to_param
#    self.id
#  end

# 现在修改下这个方法
 def to_param
  # "#{self.id}-#{self.name}"
  self.random_id
 end

 protected

 def generate_random_id
  self.random_id ||= SecureRandom.uuid
 end

end
