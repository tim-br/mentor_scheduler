class Shift < ActiveRecord::Base
  belongs_to :mentor
  validates :day, presence: true
  validates :hour, presence: true
  validates :date, presence: true
end
