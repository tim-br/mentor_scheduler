require '../.././config/environment'

class SimulatedAnneal 

  attr_accessor :current_solution, :best_solution, :new_solution

  def initialize(first_solution)
    @current_solution = DeepClone.clone first_solution
    @best_solution = DeepClone.clone first_solution
  end

  def optimize
    # self.new_solution = DeepClone.clone self.current_solution
  end

end


s = Schedule.new
#have to randomly assign shifts that 'work'
# 4 mentors
# constraint1 = mentor1, can only work after 5pm
# constraint2 = mentor2, can only work 9-2
# constraint3 = mentor3, cant work 12-3 and 6-9
# constraint4 = mentor4, cant work Tuesday
