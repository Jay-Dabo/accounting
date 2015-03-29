class Subscription < ActiveRecord::Base
  belongs_to :plan
  belongs_to :user
  has_many :payments
  validates_associated :plan, :user

  before_save :set_deadline

  def set_deadline
  	self.start = Date.today
  	self.end = Date.today + self.plan.duration.days
  end

end
