class Subscription < ActiveRecord::Base
  belongs_to :plan
  belongs_to :firm
  has_many :payments
  validates_associated :plan, :firm

  before_create :set_status, :set_deadline
  # before_save :set_status

  scope :active, -> { where(status: 1) }


private
  def set_deadline
  	self.end = self.start + self.plan.duration
  end

  def set_status
  	self.status = 1
  end

end
