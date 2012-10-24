require 'spec_helper'

describe RecipientsController do
  describe '#index' do
    context "not restricted" do

      %w(student coach admin owner).each do |role|
        context "with #{role} role" do
          before do
            sign_in(FactoryGirl.create(role))
          end
          it "should find any user by name" do
            matched_user = FactoryGirl.create :student, :first_name => 'Matched'
            not_matched_user = FactoryGirl.create :student, :first_name => 'Not matched'
            get :index, :q => 'mat', :format => :json
            response.should be_success
            assigns[:recipients].size.should == 1
          end
        end
      end

    end
    context "restricted" do
      context "with student role" do
        before do
          @user = FactoryGirl.create(:student)
          sign_in(@user)
        end

        it "should find only team users" do
          other_team = FactoryGirl.create :team
          matched_user = FactoryGirl.create :student, :first_name => 'Matched name1', :team => @user.team
          not_matched_user = FactoryGirl.create :student, :first_name => 'Matched name2', :team => other_team
          get :index, :q => 'mat', :restrict => true, :format => :json
          response.should be_success
          assigns[:recipients].size.should == 1
        end

      end

      context "with coach role" do
        before do
          @user = FactoryGirl.create(:coach)
          sign_in(@user)
        end

        it "should find only team users" do
          other_team = FactoryGirl.create :team
          matched_user = FactoryGirl.create :student, :first_name => 'Matched name1', :team => @user.team
          not_matched_user = FactoryGirl.create :student, :first_name => 'Matched name2', :team => other_team
          get :index, :q => 'mat', :restrict => true, :format => :json
          response.should be_success
          assigns[:recipients].size.should == 1
        end

      end

      context "with coach admin" do
        before do
          @user = FactoryGirl.create(:admin)
          sign_in(@user)
        end

        it "should find only team users" do
          other_team = FactoryGirl.create :team
          matched_user = FactoryGirl.create :student, :first_name => 'Matched name1', :school => @user.school
          another_team_user = FactoryGirl.create :student, :first_name => 'Matched name2', :school => @user.school
          another_school_user = FactoryGirl.create :student, :first_name => 'Matched name3'

          get :index, :q => 'mat', :restrict => true, :format => :json
          response.should be_success
          assigns[:recipients].size.should == 2
        end

      end
    end


  end
end
