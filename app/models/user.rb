class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :messages, dependent: :destroy

  def login=(login)
    @login = login
  end

  def login
    @login || self.name || self.email
  end

  def self.find_for_database_authentication(warden_conditions)
      conditions = warden_conditions.dup
      if login = conditions.delete(:login)
        where(conditions).where(["name = :value OR lower(email) = lower(:value)", { :value => login }], validate: validate_username).first
      else
        where(conditions.to_hash).first
      end
    end

  def validate_username
  	if User.where(email: name).exists?
    	errors.add(:name, :invalid)
  	end
  end
end
