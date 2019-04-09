class Event < ApplicationRecord

 validates_presence_of :name

 before_validation :generate_random_id, :on => :create

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
