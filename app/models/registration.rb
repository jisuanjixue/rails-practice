class Registration < ApplicationRecord
  STATUS = ["pending", "confirmed"]
  # 设定状态是其中的一种
  validates_inclusion_of :status, in: STATUS
  validates_presence_of :status, :ticket_id

  belongs_to :event
  belongs_to :ticket
  belongs_to :user, :optional => true

  before_validation :generate_uuid, :on => :create

  def to_param
    self.uuid
  end

  protected

  # 新建的时候乱数产生一个 UUID 来当作网址 ID。
  def generate_uuid
    self.uuid = SecureRandom.uuid
  end


end
