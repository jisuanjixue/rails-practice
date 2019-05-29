class Registration < ApplicationRecord
  # 透过 attr_accessor :current_step 我们增加一个虚拟属性(也就是数据库中并没有这个字段)来代表目前做到哪一步
  attr_accessor :current_step
  STATUS = ["pending", "confirmed"]
  # 设定状态是其中的一种
  validates_inclusion_of :status, in: STATUS
  validates_presence_of :status, :ticket_id
  # :if 这个参数可以设定调用那一个方法来决定要不要启用这个验证，回传 true 就是要，回传 false 就是不要
  validates_presence_of :name, :email, :cellphone, :if => :should_validate_basic_data?
  validates_presence_of :name, :email, :cellphone, :bio, :if => :should_validate_all_data?
  # 自定义一个资料验证, validate 可以增加自定义的资料验证，后面的 :on => :create 参数可以指定只有新建才会验证(默认是新建跟修改都会验证)
  validate :check_event_status, :on => :create

  # scope 的作用是将常用的查询条件宣告起来，方便重复使用
  scope :by_status, ->(s){ where( :status => s ) }
  scope :by_ticket, ->(t){ where( :ticket_id => t ) }

  belongs_to :event
  belongs_to :ticket
  belongs_to :user, :optional => true

  before_validation :generate_uuid, :on => :create

  def to_param
    self.uuid
  end

  def should_validate_basic_data?
    current_step == 2  # 只有做到第二步需要验证
  end

  def should_validate_all_data?
    current_step == 3 || status == "confirmed"  # 做到第三步，或最后状态是 confirmed 时需要验证
  end

  protected

  # 新建的时候乱数产生一个 UUID 来当作网址 ID。
  def generate_uuid
    self.uuid = SecureRandom.uuid
  end

  # 如果活动的状态是 draft 草稿，则不允许新增报名,* 验证不通过时，会用errors.add 增加错误讯息，第一个参数是字段名称，第二个参数是错误讯息
  # 因为表单上并没有 event_id 这个输入框，所以就算写成 errors.add(:event_id, "活动尚未开放报名") 
  # 也没有地方显示出来。依照惯例，任何不属于某个字段的错误，我们会放在 :base 上。
  def check_event_status
    if self.event.status == "draft"
      errors.add(:base, "活动尚未开放报名")
    end
  end


end
