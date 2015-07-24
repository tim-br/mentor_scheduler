class CreateAllShifts < ActiveRecord::Migration
  def change
    for i in (1..5) do 
      for j in (1..12) do
        Shift.create day: i, hour: j
      end
    end  
  end
end
