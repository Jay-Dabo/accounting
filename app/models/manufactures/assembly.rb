class Assembly < ActiveRecord::Base
  include GeneralScoping
  include Reporting
  belongs_to :firm, foreign_key: 'firm_id'
  belongs_to :product, foreign_key: 'product_id'
  has_many :processings

  accepts_nested_attributes_for :processings, reject_if: :all_blank, allow_destroy: true
  validates_associated :firm

  validates :date_of_assembly, presence: true
  validates :produced, presence: true, numericality: true
  # validates :firm_id, presence: true, numericality: { only_integer: true }

  scope :by_product, ->(product_id) { where(product_id: product_id) }

  before_create :set_defaults!
  after_create :update_cost
  after_save :touch_product

  def calculate_processings
    arr = self.processings.all
    cost = arr.map{ |processing| processing.material_cost }.compact.sum
    return cost
  end

  def total_cost
    self.material_cost + self.labor_cost + self.other_cost
  end

  def average_cost
    total_cost / self.produced
  end


  private

  def set_defaults!
    self.material_cost = 0
    if self.labor_cost.nil?
      self.labor_cost = 0
    end
    if self.other_cost.nil?
      self.other_cost = 0
    end
    self.year = self.date_of_assembly.strftime("%Y")
  end


  def touch_product
    Product.find_by_firm_id_and_id(firm_id, product_id).touch
  end

  def update_cost
    update(material_cost: calculate_processings)
  end

end