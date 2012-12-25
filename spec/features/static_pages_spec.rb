require 'spec_helper'

describe "Static Pages", :type => :feature do
  subject { page }

  describe "Home page" do
  before { visit root_path }

    it "should have the content 'Sample App'" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      should have_selector('h1', text: 'Sample App')
      # should have_selector('title', text: full_title(''))
    end
  end

  describe "Help page" do
    before { visit help_path }
    it "shoud have the content 'Help'" do
      should have_selector('h1', text: 'Help')
      # should have_selector('title', text: full_title('Help'))
    end
  end

  describe "Contact page" do
    before {visit contact_path }
    it "shoud have the content 'Contact'" do
      should have_selector('h1', text: 'Contact Us')
      # should have_selector('title', text: full_title('Contact'))
    end
  end

  describe "About Page" do
    before { visit about_path }
    it "should have the content 'About Us'" do
      should have_selector('h1', text: 'About Us')
      # should have_selector('title', text: full_title('About'))
    end
  end
end
