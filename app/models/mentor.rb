class Mentor < ActiveRecord::Base
  has_many :shifts
  has_many :constraints
  validates :full_name, presence: true
  validates :email, presence: true, uniqueness: true

  def check_if_available?(shift)
    !self.constraints.find_by_day_and_hour(shift.day, shift.hour)
  end

  def working_on_day?(day)
    self.shifts.where(day: day).count > 0
  end

  def total_hours_on_day(day)
    self.shifts.where(day: day).count
  end

  def total_hours
    self.shifts.count
  end
  
end
