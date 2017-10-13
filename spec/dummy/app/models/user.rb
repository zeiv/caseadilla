class User < ApplicationRecord
  belongs_to :role
  has_many :posts

  before_save :add_user_role

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def role_symbols
    [role.title.to_sym]
  end

  def name
    "#{first_name} #{last_name}"
  end

  private

  def add_user_role
    role = Role.find_by(title: 'user')
  end
end
