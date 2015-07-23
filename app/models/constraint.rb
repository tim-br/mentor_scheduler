class Constraint < ActiveRecord::Base
  belongs_to :mentor
  validates :day, presence: true
  validates :hour, presence: true

end
