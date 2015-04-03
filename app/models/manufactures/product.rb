class Product < ActiveRecord::Base
  belongs_to :firm, foreign_key: 'firm_id'
  validates_associated :firm

  validates :product_name, presence: true
  validates :quantity, presence: true, numericality: true
  # validates :cost, presence: true, numericality: true
  # validates :price, presence: true
  # validates :firm_id, presence: true, numericality: { only_integer: true }

end