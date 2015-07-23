require './spec/spec_helper'

describe "admin_tests" do 

  before :all do
    Admin.create(full_name: "test admin", email: "test@test.com", password: '123', password_confirmation: '123')   
    @admin = Admin.last
  end

  describe "#new" do 

    it "should have a full name" do 
      expect(@admin.full_name).to eq("test admin")
    end

    it "should not store the password" do 
      expect(@admin.password).to be_falsey
    end

    it "should not save if password confirmation doesnt match" do 
      Admin.create(full_name: "test admin2", email: "test2@test.com", password: '123', password_confirmation: '321')
      expect(Admin.last.full_name).to eq("test admin")
    end

    it "should not allow duplicate emails" do 
      Admin.create(full_name: "test admin2", email: "test@test.com", password: '123', password_confirmation: '123')
      expect(Admin.last.full_name).to eq("test admin")
    end

  end

  describe "#authentication" do 

    it "should fail if password is wrong" do 
      expect(@admin.authenticate("321")).to be_falsey
    end

    it "should return true if password is correct" do 
      expect(@admin.authenticate("123")).to be_truthy
    end

  end

    after :all do 
      @admin.destroy
    end

end