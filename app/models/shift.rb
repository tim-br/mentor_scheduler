class Shift < ActiveRecord::Base
  belongs_to :mentor
  validates :mentor, presence: true
  validates :day, presence: true
  validates :hour, presence: true
  validates :date, presence: true

  def start_time

  end

  def end_time

  end

  def shift_time_to_string

  end

  def mentor_to_string
    "This shift belongs to #{self.mentor.full_name}"
  end


end
