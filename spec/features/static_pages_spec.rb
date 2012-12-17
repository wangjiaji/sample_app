require 'spec_helper'

describe "Static Pages", :type => :feature do
  describe "Home page" do
    it "should have the content 'Sample App'" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      visit('/static_pages/home')
      page.should have_selector('h1', :text => 'Sample App')
    end
  end

  describe "Help page" do
    it "shoud have the content 'Help'" do
      visit('/static_pages/help')
      page.should have_selector('h1', :text => 'Help')
    end
  end

  describe "About Page" do
    it "should have the content 'About Us'" do
      visit '/static_pages/about'
      page.should have_selector('h1', :text => 'About Us')
    end
  end
end