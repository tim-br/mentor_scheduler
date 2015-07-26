class InsertDummyMentor < ActiveRecord::Migration
  def change
    Mentor.create full_name: "No mentors available", email: "this_is_bad@mail.com"
  end
end
