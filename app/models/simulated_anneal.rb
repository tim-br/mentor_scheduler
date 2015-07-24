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

# s = Schedule.new
