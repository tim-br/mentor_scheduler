require './spec/spec_helper'

describe "mentor tests" do

  before :all do
    Mentor.create(full_name: "test mentor", email: "test@test.com")
    @mentor = Mentor.last
    Constraint.create(mentor_id: @mentor.id, day: 1, hour: 1)
    @constraint = Constraint.last
    @mentor.constraints << @constraint
    Shift.create(mentor_id: @mentor.id, day: 1, hour: 1, date: Date.new(2012,3,5))
    @shift = Shift.last
    @mentor.shifts << @shift
  end

  describe "#new" do

    it "should have a full name" do
      expect(@mentor.full_name).to eq("test mentor")
    end

    it "should not save if full_name is blank" do
      Mentor.create(email: "test2@test.com")
      expect(Mentor.last.email).to eq("test@test.com")
    end

    it "should not allow duplicate emails" do
      Mentor.create(full_name: "test mentor2", email: "test@test.com")
      expect(Mentor.last.full_name).to eq("test mentor")
    end

  end

  describe "#constraints" do

    it 'can have constraints' do
      expect(@mentor.constraints.first).to eq(@constraint)
    end

  end

  describe "#email" do
    it " must not be nil" do
    @mentor.email = nil
    expect(@mentor).to_not be_valid
    expect(@mentor.errors[:email]).to eq ["can't be blank"]
    end
  end

  # describe "#shifts_on" do
  #   it "must return the shifts on the date" do
  #     @mydate = Date.new(2014,3,8)
  #     @shift.date = @mydate
  #     @myarray = []
  #     @myarray << @shift.date
  #     #binding.pry
  #     expect(@mentor.shifts_on(@mydate).to eq(@myarray))
  #   end
  # end

  describe "#shifts" do

    it "can have assigned shift" do
      expect(@mentor.shifts.first).to eq(@shift)
    end

  end

  after :all do
    @mentor.destroy
    @constraint.destroy
    @shift.destroy
  end

end
