class Shift < ActiveRecord::Base
  belongs_to :mentor
  validates :mentor, presence: true
  validates :day, presence: true, numericality: { only_integer: true }
  validates :hour, presence: true, numericality: { only_integer: true }
  validates :date, presence: true

  def mentor_to_string
    "This shift belongs to #{self.mentor.full_name}"
  end

end
