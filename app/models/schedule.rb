require './config/environment'

class Schedule

  def initialize
    Shift.all.each do |shift|
      count = 0
      mentor_array = Mentor.all
      begin
        count+=1
        shift.mentor = mentor_array.sample
        if shift.mentor.check_if_available?(shift)                
          shift.save
        end                
        mentor_array.delete(shift.mentor)
      end while(shift.mentor.nil? && count<20)
      puts "no mentor found" if shift.mentor.nil?
    end
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