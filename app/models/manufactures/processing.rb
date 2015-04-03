class Processing < ActiveRecord::Base
  belongs_to :material, foreign_key: 'material_id'
  belongs_to :assembly, foreign_key: 'assembly_id'
  validates_associated :firm

  validates :quantity_used, presence: true
  # validates :cost, presence: true, numericality: true
  # validates :firm_id, presence: true, numericality: { only_integer: true }

end