class Mentor < ActiveRecord::Base
  has_many :shifts
  has_many :constraints
  validates :full_name, presence: true
  validates :email, presence: true, uniqueness: true
end
