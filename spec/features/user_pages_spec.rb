require 'spec_helper'

describe "UserPages", type: :feature do
  subject { page }

  describe 'index' do
    let(:user) { FactoryGirl.create(:user) }

    before do
      sign_in user
      visit users_path
    end

    it { should have_selector('h1', text: 'All Users') }

    describe 'pagination' do
      before(:all) { 30.times { FactoryGirl.create(:user) }}
      after(:all) { User.delete_all }

      it { should have_selector('div.pagination') }
      it 'should list each user' do
        User.paginate(page: 1).each do |user|
          page.should have_selector('li', text: user.name)
        end
      end
    end

    describe 'delete links' do
      it { should_not have_link('delete') }
      describe 'as an admin user' do
        let(:admin) { FactoryGirl.create(:admin) }
        before do
          sign_in admin
          visit users_path
        end

        it { should have_link('delete', href: user_path(User.first)) }
        it 'should be able to delete another user' do
          expect { click_link('delete') }.to change(User, :count).by(-1)
        end
        it { should_not have_link('delete', href: user_path(admin)) }
      end
    end
  end

  describe "signup page" do
    before { visit signup_path }

    it { should have_selector('h1', text: 'Sign up') }
  end

  describe 'profile page' do
    let(:user) { FactoryGirl.create(:user) }
    let!(:m1) { FactoryGirl.create(:micropost, user: user, content: 'foo') }
    let!(:m2) { FactoryGirl.create(:micropost, user: user, content: 'bar') }
    before { visit user_path(user) }

    it { should have_selector('h1', text: user.name) }

    describe 'microposts' do
      it { should have_content(m1.content) }
      it { should have_content(m2.content) }
      it { should have_content(user.microposts.count) }
    end
  end

  describe 'signup' do
    before { visit signup_path }
    let(:submit) { 'Create my account' }

    describe 'with invalid information' do
      it 'should not create a user' do
        expect { click_button submit }.not_to change(User, :count)
      end

      describe 'after submission' do
        before { click_button submit }

        it { should have_selector('h1', text: 'Sign up') }
        it { should have_content('error') }
      end
    end

    describe 'with valid information' do
      before do
        fill_in 'Name', with: 'Jiaji Wang'
        fill_in 'Email', with: 'jiaji.wang@gmail.com'
        fill_in 'Password', with: 'foobar'
        fill_in 'Confirmation', with: 'foobar'
      end
      
      it 'should create a user' do
        expect { click_button submit }.to change(User, :count).by(1)
      end

      describe 'after submission' do
        before { click_button submit }
        let(:user) { User.find_by_email('jiaji.wang@gmail.com') }

        it { should have_selector('h1', text: user.name) }
        it { should have_selector('div.alert.alert-success', text: 'Welcome') }
        it { should have_link('Sign out') }

        describe 'followed by signout' do
          before { click_link 'Sign out' }

          it { should have_link('Sign in') }
        end
      end
    end
  end

  describe 'edit' do
    let(:user) { FactoryGirl.create(:user) }
    before do
      sign_in user
      visit edit_user_path(user)
    end

    describe 'page' do
      it { should have_selector('h1', text: 'Update your profile') }
      it { should have_link('Change', href: 'http://gravatar.com/emails') }
    end

    describe 'with invalid information' do
      before { click_button 'Save Changes' }

      it { should have_content('error') }
    end


    describe 'with valid information' do
      let(:new_name) { 'New name' }
      let(:new_email) { 'new@example.com' }
      before do
        fill_in 'Name', with: new_name
        fill_in 'Email', with: new_email
        fill_in 'Password', with: user.password
        fill_in 'Confirmation', with: user.password
        click_button 'Save Changes'
      end

      it { should have_selector('div.alert.alert-success') }
      it { should have_link('Sign out', href: signout_path) }
      specify { user.reload.name.should == new_name }
      specify { user.reload.email.should == new_email }
    end
  end

end
