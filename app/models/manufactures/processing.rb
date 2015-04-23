class Processing < ActiveRecord::Base
  belongs_to :material, foreign_key: 'material_id'
  belongs_to :assembly, foreign_key: 'assembly_id'
  validates_associated :material, :assembly

  validates :quantity_used, presence: true
  # validates :cost, presence: true, numericality: true
  # validates :firm_id, presence: true, numericality: { only_integer: true }

  scope :by_assembly, ->(assembly_id) { where(assembly_id: assembly_id) }
  scope :by_material, ->(material_id) { where(material_id: material_id) }

  before_save :calculate_cost!
  after_save :touch_material

  def material_cost
    self.quantity_used * self.material.cost_per_unit
  end

  private

  def touch_material
    Material.find_by_id(material_id).touch
  end

  def calculate_cost!
    self.cost_used = material_cost
  end

end