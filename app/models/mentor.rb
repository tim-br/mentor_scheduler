class Mentor < ActiveRecord::Base
  has_many :shifts
  has_many :constraints
  validates :full_name, presence: true
  validates :email, presence: true, uniqueness: true

  #returns active record relation
  def shifts_on(date)
    Shift.where(date: date).order("hour ASC")
    # a = []
    # s.each {|row| a<<row.date}
  end

  def total_hours_on(date)
    shifts_for_date(date).count
  end

  def hours_on(date)
    shifts_for_date.select(:hour)
  end

  def number_of_blocks_on(date)
  end

  def check_if_available?(shift)
    !self.constraints.find_by_day_and_hour(shift.day, shift.hour)
  end
  
end
