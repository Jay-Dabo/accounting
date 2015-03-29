class Plan < ActiveRecord::Base
  has_many :subscriptions

  validates :name, presence: true
  validates :price, presence: true
  validates :duration, presence: true
end
