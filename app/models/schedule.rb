#require './config/environment'

class Schedule

  attr_accessor :shifts, :score

  def initialize
    Shift.update_all mentor_id: nil
    @shifts = []
    mentor_array = Mentor.all.to_a
    Shift.all.order(:id).each do |shift|
      mentor_array_copy = mentor_array.dup
      mentor_array_copy.delete(Mentor.find(6))
      assigned = nil
      count = 0
      #if this is the last shift of the day, it must be assingned the previous mentor
      #if that mentor is not available, shift is empty
      if (shift.id)%12==0
        previous_mentor = Shift.find(shift.id-1).mentor
        if previous_mentor.check_if_available?(shift) && previous_mentor.total_hours_on_day(shift.day) <3
          shift.mentor = previous_mentor
          shift.save
          @shifts << shift
          assigned = true
        end     
      else
        begin
          #check once if the previous mentor is available and has less than 2 shifts that day
          if count == 0 && shift.id>1 && shift.id%12!=1
            previous_mentor = Shift.find(shift.id-1).mentor 
            count = 1
            if previous_mentor && previous_mentor.total_hours_on_day(shift.day) == 1 && previous_mentor.check_if_available?(shift)
              shift.mentor = previous_mentor
              shift.save
              @shifts << shift
              assigned = true
            else
              mentor_array_copy.delete(previous_mentor)
            end
          else
            sample_mentor = mentor_array_copy.sample
            if sample_mentor.check_if_available?(shift)
              if sample_mentor.working_on_day?(shift.day)
                hours_assigned = sample_mentor.shifts.where(day: shift.day).map &:hour
                if hours_assigned.include?(shift.hour-1) && hours_assigned.length <3
                  shift.mentor = sample_mentor
                  shift.save
                  @shifts << shift
                  assigned = true
                else
                  mentor_array_copy.delete(sample_mentor)
                end
              else
                shift.mentor = sample_mentor
                shift.save
                @shifts << shift
                assigned = true
              end
            else
              mentor_array_copy.delete(sample_mentor)
            end              
          end  
        end while(mentor_array_copy.length>0 && assigned.nil?)
      end
      if assigned.nil?
        shift.mentor = Mentor.find(6) 
        shift.save
        @shifts << shift
      end
    end
  end

  def score_calculator
    self.score = 100
    #valid?: Is every shift filled?
    unless self.valid?
      return 0
    end
    #has every TA been assigned a shift?
    Mentor.all.each do |mentor|
      if mentor.id !=6
        if Shift.where(mentor_id: mentor.id).count == 0
          self.score -= 1
        end
      end
    end
    #does a TA have gaps in their shifts on the same day?
    for i in (1..5) do 
      Mentor.all.each do |mentor| 
        self.score-=shift_gap_checker(mentor, i)
      end
    end
    #does a TA have a shift of 1 hour?
    Mentor.all.each do |mentor|
      mentor_days = (mentor.shifts.map &:day).uniq.sort
      mentor_days.each do |day|
        if mentor.shifts.where(day: day).count == 1
          self.score -= 1
        end
      end
    end
    return self.score
    #are any constraints broken?
  end

  def valid?
    (self.shifts.select {|shift| shift.mentor_id == 6 }).length == 0
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
    mentor_shifts = mentor.shifts.where(day: day)
    shift_hours += hours((mentor_shifts.map &:hour).sort)
  end

end
