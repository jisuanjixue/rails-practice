class Event < ApplicationRecord

 validates_presence_of :name

 # 在调用路由方法时，Rails 默认都会用 to_param 方法来转换 ID,
#  def to_param
#    self.id
#  end

# 现在修改下这个方法
 def to_param
  "#{self.id}-#{self.name}"
 end

end
