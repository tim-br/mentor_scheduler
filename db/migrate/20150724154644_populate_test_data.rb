class PopulateTestData < ActiveRecord::Migration

  def change
    Admin.create full_name: "Test Admin", email: "test@test.com", password: "123", password_confirmation: "123"
    Mentor.create full_name: "TM1", email: "TM1@TM.com"
    Mentor.create full_name: "TM2", email: "TM2@TM.com"
    Mentor.create full_name: "TM3", email: "TM3@TM.com"
    Mentor.create full_name: "TM4", email: "TM4@TM.com"
    #mentor 1 constraints
    for i in (1..8) do 
      for j in (1..5) do 
        Constraint.create mentor_id: 1, day: j, hour: i
      end
    end
    #mentor 2 constraints
    for i in (6..12) do 
      for j in (1..5) do 
        Constraint.create mentor_id: 2, day: j, hour: i
      end
    end
    #mentor 3 constraints
    for i in (4..6) do 
      for j in (1..5) do 
        Constraint.create mentor_id: 3, day: j, hour: i
      end
    end
    for i in (10..12) do 
      for j in (1..5) do 
        Constraint.create mentor_id: 3, day: j, hour: i
      end
    end
    #mentor 4 constraints
    for i in (1..12) do 
      Constraint.create mentor_id: 4, day: 2, hour: i
    end
  end
end
