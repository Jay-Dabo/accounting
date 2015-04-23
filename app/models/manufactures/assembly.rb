class Assembly < ActiveRecord::Base
  include GeneralScoping
  include Reporting
  belongs_to :firm, foreign_key: 'firm_id'
  belongs_to :product, foreign_key: 'product_id'
  has_many :processings

  accepts_nested_attributes_for :processings, reject_if: :all_blank, allow_destroy: true
  validates_associated :firm

  # validates :date_of_assembly, presence: true
  validates_presence_of :year
  validates :produced, presence: true, numericality: true
  # validates :firm_id, presence: true, numericality: { only_integer: true }

  scope :by_product, ->(product_id) { where(product_id: product_id) }

  attr_accessor :date, :month

  before_save :set_defaults!
  # after_create :update_cost
  after_save :touch_product


  def total_cost
    self.material_cost + self.labor_cost + self.other_cost
  end

  def average_cost
    total_cost / self.produced
  end

  def calculate_materials
    processings.reject(&:marked_for_destruction?).sum(&:material_cost)
    # processings.reject(&:marked_for_destruction?).inject(0) do |sum, item|
    #   sum = (item.material_cost)
    # end
  end

  private

  def set_defaults!
    unless date == nil || month = nil || year = nil 
      self.date_of_assembly = "#{self.year}-#{self.month}-#{self.date}"
    end
    self.material_cost = calculate_materials
    default_labor_cost
    default_other_cost
    # self.year = self.date_of_assembly.strftime("%Y")
  end

  # def set_defaults!
  #   self.material_cost = 0
  #   if self.labor_cost.nil?
  #     self.labor_cost = 0
  #   end
  #   if self.other_cost.nil?
  #     self.other_cost = 0
  #   end
  #   self.date_of_assembly = "#{self.year}-#{self.month}-#{self.date}"
  #   # self.year = self.date_of_assembly.strftime("%Y")
  # end

  def default_labor_cost
    if self.labor_cost.nil?
      self.labor_cost = 0
    end    
  end

  def default_other_cost
    if self.other_cost.nil?
      self.other_cost = 0
    end
  end
  def touch_product
    Product.find_by_firm_id_and_id(firm_id, product_id).touch
  end

  def update_cost
    update(material_cost: calculate_processings)
  end

end