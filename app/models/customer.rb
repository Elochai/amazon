class Customer < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :orders, dependent: :destroy
  has_many :credit_cards, dependent: :destroy
  
  validates :email, format: { with: /\A.+@.+\z/ }, uniqueness: true, presence: true
  validates :password, presence: true
  validates :firstname, :lastname, presence: true
end
