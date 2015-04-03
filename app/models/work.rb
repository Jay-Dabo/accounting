class Work < ActiveRecord::Base
  belongs_to :firm, foreign_key: 'firm_id'
  has_many :revenues, as: :item
  validates_associated :firm

  scope :by_firm, ->(firm_id) { where(firm_id: firm_id)}

end
