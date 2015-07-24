require './config/environment'

class Schedule

  def initialize
    mentor_array = Mentor.all.to_a
    Shift.all.each do |shift|
      mentor_array_copy = mentor_array.dup
      begin
        sample_mentor = mentor_array_copy.sample
        if sample_mentor.check_if_available?(shift)              
          shift.mentor = sample_mentor
          shift.save
        else
          mentor_array_copy.delete(sample_mentor)
        end                
      end while(shift.mentor.nil? && mentor_array_copy.length>0)
      puts "no mentor found for shift #{shift.id}" if shift.mentor.nil?
    end
  end

  def score
    #valid?: Is every shift filled?
    unless self.valid?
      return 0
    end
    #has every TA been assigned a shift?
    #does a TA have gaps in their shifts on the same day?
    #

  end

  def valid?
    Shift.where(mentor_id: nil).count == 0
  end

end

Schedule.new

#loop through each shift
#for each shift, randomly assign mentor 
#remove mentor from mentor_array
#check if constraints satisfied (mentor.check_if_available?(shift)
#if true, save shift
#if false, pick other mentor
#if none are valid, throw error