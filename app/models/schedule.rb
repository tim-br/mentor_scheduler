require './config/environment'

class Schedule

  attr_accessor :shifts

  def initialize
    @shifts = []
    mentor_array = Mentor.all.to_a
    Shift.all.each do |shift|
      mentor_array_copy = mentor_array.dup
      begin
        sample_mentor = mentor_array_copy.sample
        if sample_mentor.check_if_available?(shift)              
          shift.mentor = sample_mentor
          shift.save
          @shifts << shift
        else
          mentor_array_copy.delete(sample_mentor)
        end                
      end while(shift.mentor.nil? && mentor_array_copy.length>0)
      puts "no mentor found for shift #{shift.id}" if shift.mentor.nil?
    end
  end

  # def score
  #   @score = 1000
  #   #valid?: Is every shift filled?
  #   unless self.valid?
  #     return 0
  #   end
  #   #has every TA been assigned a shift?
  #   #does a TA have gaps in their shifts on the same day?
  #   Mentor.each do |mentor|
  #     mentor_shifts = self.shifts.select {|shift| shift.mentor == mentor}
  #     if mentor_shifts.length == 0
  #       @score -= 1
  #     else
  #       mentor_shifts_days = (mentor_shifts.map &:day).uniq
  #       mentor_shifts_days.each |day| do 
  #         shift_start_hours = mentor_shifts.select {|shift| shift.day = day}

  #       end

  #     end
  #   end

  # end

  def valid?
    self.shifts.select {|shift| shift.mentor_id == nil }.length == 0
  end

  def hours(arr)
    count = 0
    arr << arr.last+1 if arr.length%2!=0
    previous_number = arr.first
    for i in (1..arr.length-1) do 
      count += (arr[i] - previous_number - 1)
      previous_number = arr[i]
    end
    count
  end

  def shift_gap_checker
    Mentor.all.each do |mentor|
      mentor_shifts = self.shifts.select {|shift| shift.mentor == mentor}
      mentor_shifts_days = (mentor_shifts.map &:day).uniq
      mentor_shifts_days.each do |day| 
        shifts_of_day = mentor_shifts.select {|shift| shift.day = day}
        shift_hours = hours((shifts_of_day.map &:hour).sort)
        puts "On day #{day}, mentor #{mentor.full_name} has #{shift_hours} of gaps" 
      end
    end
  end

end
