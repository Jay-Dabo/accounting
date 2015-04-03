class Assembly < ActiveRecord::Base
  belongs_to :firm, foreign_key: 'firm_id'
  belongs_to :product, foreign_key: 'product_id'
  has_many :processings

  accepts_nested_attributes_for :processings, reject_if: :all_blank, allow_destroy: true
  validates_associated :firm

  validates :date_of_assembly, presence: true
  validates :quantity, presence: true, numericality: true
  # validates :cost, presence: true, numericality: true
  # validates :price, presence: true
  # validates :firm_id, presence: true, numericality: { only_integer: true }

end