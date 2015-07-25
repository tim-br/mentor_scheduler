#require './config/environment'

class Schedule

  attr_accessor :shifts, :score

  def initialize
    @shifts = []
    mentor_array = Mentor.all.to_a
    Shift.all.each do |shift|
      mentor_array_copy = mentor_array.dup
      assigned = nil
      begin
        sample_mentor = mentor_array_copy.sample
        if sample_mentor.check_if_available?(shift)              
          shift.mentor = sample_mentor
          shift.save
          @shifts << shift
          assigned = true
        else
          mentor_array_copy.delete(sample_mentor)
        end                
      end while(assigned.nil? && mentor_array_copy.length>0)
    end
  end

  def score_calculator
    self.score = 100
    #valid?: Is every shift filled?
    unless self.valid?
      return 0
    end
    #has every TA been assigned a shift?
    #does a TA have gaps in their shifts on the same day?
    for i in (1..5) do 
      Mentor.all.each do |mentor| 
        self.score-=shift_gap_checker(mentor, i)
      end
    end
    return self.score
    #are any constraints broken?
  end

  def valid?
    self.shifts.select {|shift| shift.mentor_id == nil }.length == 0
  end

  def hours(arr)
    count = 0
    previous_number = arr.first
    for i in (1..arr.length-1) do 
      count += (arr[i] - previous_number - 1)
      previous_number = arr[i]
    end
    count
  end

  def shift_gap_checker(mentor, day)
    shift_hours = 0
    mentor_shifts = self.shifts.select {|shift| shift.mentor == mentor}
    mentor_shift_days = mentor_shifts.select {|shift| shift.day == day}
    # mentor_shifts_days = (mentor_shifts.map &:day).uniq.sort
    # mentor_shifts_days.each do |day| 
    #   shifts_of_day = mentor_shifts.select {|shift| shift.day == day}
    # shift_hours += hours((shifts_of_day.map &:hour).sort)
    shift_hours += hours((mentor_shift_days.map &:hour).sort)
    # end
    # return shift_hours
  end

end
