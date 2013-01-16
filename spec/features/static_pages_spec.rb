require 'spec_helper'

describe "Static Pages", :type => :feature do
  subject { page }

  shared_examples_for 'all static pages' do
    it { should have_selector('h1', text: heading) }
  end

  describe "Home page" do
    before { visit root_path }
    let(:heading) { 'Sample App' }

    it_should_behave_like 'all static pages'

    describe 'for signed-in users' do
      let(:user) { FactoryGirl.create(:user) }
      before do
        FactoryGirl.create(:micropost, user: user, content: 'lorem ipsum')
        FactoryGirl.create(:micropost, user: user, content: 'dolor sit amet')
        sign_in user
        visit root_path
      end

      it 'should render user feed' do
        user.feed.each do |item|
          page.should have_selector("li##{item.id}", text: item.content)
        end
      end
    end
  end

  describe "Help page" do
    before { visit help_path }
    let(:heading) { 'Help' }

    it_should_behave_like 'all static pages'
  end

  describe "Contact page" do
    before {visit contact_path }
    let(:heading) { 'Contact Us' }

    it_should_behave_like 'all static pages'
  end

  describe "About Page" do
    before { visit about_path }
    let(:heading) { 'About Us' }

    it_should_behave_like 'all static pages'
  end
end
