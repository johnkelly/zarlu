require 'spec_helper'

describe "user with expired trial" do
  let(:user) { users(:expiredmanager_example_com) }

  before do
    visit '/users/sign_in'
    within '#new_user' do
      fill_in 'Email', with: 'expiredmanager@example.com'
      fill_in 'Password', with: 'password'
    end
    within '.devise_box' do
      click_button "Sign In"
    end
  end

  describe "sign_in" do
    it "shows flash error message" do
      page.should have_content 'Your 30 day trial has expired.'
      page.should have_content 'Please add your credit card to continue using Zarlu.'
      page.should have_content 'Feel free to contact us with any questions you may have.'
    end
  end

  it "redirect to add credit card page " do
    page.should have_selector '#stripe_error'
    page.should have_selector '#card_number'
    page.should have_selector '#card_code'
    page.should have_selector '#card_month'
    page.should have_selector '#card_year'
  end

  describe "all subscription pages redirect to credit card page" do
    it "redirects from welcome" do
      click_link 'Welcome'
      page.should have_selector '#card_number'
    end

    it "redirects from activity feed" do
      click_link 'Activity Feed'
      page.should have_selector '#card_number'
    end

    it "redirects from calendar" do
      click_link 'Calendar'
      page.should have_selector '#card_number'
    end

    it "redirects from time off requests" do
      click_link 'Time Off Requests'
      page.should have_selector '#card_number'
    end

    it "redirects from employees" do
      click_link 'Employees'
      page.should have_selector '#card_number'
    end

    it "redirects from company settings" do
      click_link 'Company Settings'
      page.should have_selector '#card_number'
    end
  end

  describe "can access user account, sign out, and public pages" do
    it "renders user account" do
      click_link 'My Settings'
      page.should have_content 'Cancel my account'
    end

    it "renders user account" do
      click_link 'Sign Out'
      page.should have_content 'Signed out! Thank you for using Zarlu.'
    end

    it "renders home page" do
      click_link 'Zarlu'
      page.should have_content 'Employee Time & Attendance Software'
    end
  end
end
