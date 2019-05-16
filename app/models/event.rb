class Event < ApplicationRecord
  #排序
  include RankedModel
  ranks :row_order
  
  has_many :registrations, :dependent => :destroy
  has_many :tickets, :dependent => :destroy, :inverse_of  => :event
  belongs_to :category, :optional => true
  # 某些版本的Rails 有个accepts_nested_attributes_for 的bug 让has_many 故障了，需要额外补上inverse_of 参数，不然存储时会找不到tickets
  accepts_nested_attributes_for :tickets, :reject_if => :all_blank, allow_destroy: true
 
  validates_presence_of :name, :random_id
 validates_uniqueness_of :random_id, message: "必须不相同"
 validates_format_of :random_id, with: /\A[a-z0-9\-]+\z/, message: "无效的格式"

 before_validation :generate_random_id, on: :create

 # 加上状态字段的验证
 STATUS = ["草稿", "公开", "私人"]
 validates_inclusion_of :status, :in => STATUS

 # 在调用路由方法时，Rails 默认都会用 to_param 方法来转换 ID,
#  def to_param
#    self.id
#  end

 def to_param
  # "#{self.id}-#{self.name}"
  self.random_id
 end

 protected

 def generate_random_id
  self.random_id ||= SecureRandom.uuid
 end

end
