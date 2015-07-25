#require '../.././config/environment'

class SimulatedAnneal 

  attr_accessor :current_solution, :best_solution, :new_solution

  def initialize(first_solution)
    @current_solution = DeepClone.clone first_solution
    @best_solution = DeepClone.clone first_solution
  end

  def optimize(temp, cooling_rate)
    while(temp>0.1)
      self.new_solution = DeepClone.clone self.current_solution
      # temp = 10
      # cooling_rate = 0.03
      #switch two random TA assignments, not caring about constraints
      shift_position_1 = rand(0...Shift.all.count)
      shift_position_2 = rand(0...Shift.all.count)

      temp_mentor = self.new_solution.shifts[shift_position_1].mentor
      self.new_solution.shifts[shift_position_1].mentor = self.new_solution.shifts[shift_position_2].mentor
      self.new_solution.shifts[shift_position_2].mentor = temp_mentor

      energy = self.best_solution.score_calculator
      new_energy = self.new_solution.score_calculator

      if new_energy > energy
        self.best_solution = DeepClone.clone self.new_solution
      elsif acceptance_probability(energy, new_energy, temp) > rand
        self.current_solution = DeepClone.clone self.new_solution
      end
      temp *= (1-cooling_rate)
    end
  end

  def acceptance_probability(energy, new_energy, temp)
    # (new_energy - energy) / temp
    1/( 1 + ( (energy - new_energy ) / temp ) )
  end

end


# s = Schedule.new
# sa = SimulatedAnneal.new(s)
# sa.optimize
#have to randomly assign shifts that 'work'
# 4 mentors
# constraint1 = mentor1, can only work after 5pm
# constraint2 = mentor2, can only work 9-2
# constraint3 = mentor3, cant work 12-3 and 6-9
# constraint4 = mentor4, cant work Tuesday
