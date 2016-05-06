class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy

  validates :name, presence: true

  def author_of(model)
    id == model.user.id if model.respond_to?(:user)
  end
end
