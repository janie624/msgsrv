require 'spec_helper'

describe User do
  
  before { @user =  FactoryGirl.create :user, team_id: 2 }

  it { User.new.should be_an_instance_of(User) }
  it { @user.should be_valid }
  
  describe "#presence of 'first_name'" do
    before { @user.first_name = '' }
    it { @user.should_not be_valid }
  end

  describe "#presence of 'last_name'" do
    before { @user.last_name = '' }
    it { @user.should_not be_valid }
  end
  
  describe "#uniqueness of 'email'" do
    before { @new_user = FactoryGirl.create :student, team_id: 2 }
    before { @new_user.email = @user.email }    
    it { @new_user.should_not be_valid }
  end
  
  describe "#format of 'email'" do
    before { @user.email = 'invalid_email' }    
    it { @user.should_not be_valid }
  end
  
  describe "#team must be selected for coach and student" do
    before do
      @new_user = FactoryGirl.create :coach, team_id: 2
    end

    it "invalid nil for team_id" do
      @new_user.team_id = nil
      @new_user.should_not be_valid
    end
    
    context "invalid 0 for team_id" do
      before { @new_user.team_id = 0 }
      it { @new_user.should_not be_valid }
    end
    
    context "invalid '' for team_id" do
      before { @new_user.team_id = 0 }
      it { @new_user.should_not be_valid }
    end
  end
  
  describe "#team cannot be selected for admin" do  
    before { @new_user = FactoryGirl.create :admin, team_id: nil, school_id: 2 }
    before { @new_user.team_id = 1 }    
    it { @new_user.should_not be_valid }
  end

  describe "#presence of 'school_id'" do
    before { @user.school_id = '' }
    it { @user.should_not be_valid }
  end
end