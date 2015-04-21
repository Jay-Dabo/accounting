class User < ActiveRecord::Base  
# Relations
  has_one  :subscription
  has_many :payments, through: :subscription
  has_many :posts

  has_many :memberships
  has_many :firms, through: :memberships
  # delegate :tradings, :services, :manufacturers, to: :firms

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :trackable, :validatable#, :confirmable
  
  # Pagination
  paginates_per 100

  # Validations
  # :email
  validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i

  # validates_presence_of     :username
  # validates_uniqueness_of   :username, :case_sensitive => false 
  # validates_length_of       :username, maximum: 15, minimum: 5 
  # validates :username, format: { with: /\A[a-zA-Z0-9]+\Z/ }

  attr_accessor :first_name, :last_name, :login
  before_create :set_full_name

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions.to_hash).where(
        ["lower(phone_number) = :value OR lower(email) = :value", 
        { :value => login.downcase }]
      ).first
    else
      where(conditions.to_hash).first
    end
  end      

  def self.paged(page_number)
    order(admin: :desc, email: :asc).page page_number
  end

  def self.search_and_order(search, page_number)
    if search
      where("email LIKE ?", "%#{search.downcase}%").order(
      admin: :desc, email: :asc
      ).page page_number
    else
      order(admin: :desc, email: :asc).page page_number
    end
  end

  def self.last_signups(count)
    order(created_at: :desc).limit(count).select("id","email","created_at")
  end

  def self.last_signins(count)
    order(last_sign_in_at:
    :desc).limit(count).select("id","email","last_sign_in_at")
  end

  def self.users_count
    where("admin = ? AND locked = ?",false,false).count
  end

  def find_membership(firm)
    Membership.find_by_user_id_and_firm_id(self.id, firm.id)
  end

  
  private
  
  def set_full_name
    first = first_name.titleize
    if last_name.nil?
      last = ""
    else
      last = last_name.titleize
    end
    self.full_name = "#{first}#{last}"
  end

end
