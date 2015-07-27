class Admin < ActiveRecord::Base
  
  has_secure_password

  validates :full_name, presence: true
  validates :email, presence: true, uniqueness: true

  attr_accessor :schedule

end
