require 'spec_helper'

describe HomeController do
  describe "GET index" do
    it "should render owner index page" do
      sign_in FactoryGirl.create(:owner)
      get 'index'
      should render_template('index')
    end
    
    it "should render admins index page" do
      sign_in FactoryGirl.create :admin, team: nil
      get 'index'
      should render_template('index')
    end

    it "should render coachs index page" do
      sign_in FactoryGirl.create :coach
      get 'index'
      should render_template('index')
    end
    
    it "should render students index page" do
      sign_in FactoryGirl.create :student
      get 'index'
      should render_template('index')
    end
  end
end
