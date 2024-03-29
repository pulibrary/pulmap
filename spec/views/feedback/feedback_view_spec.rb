# frozen_string_literal: true

require "rails_helper"

describe "Feedback Form", type: :feature do
  context "when user has not signed in" do
    before do
      visit("/catalog/princeton-cv43nz62s")
      click_link("Contact Us")
    end

    it "Displays an empty form" do
      expect(page).to have_content "Contact Us"
      expect(page).to have_field "feedback_form_name"
      expect(page).to have_field "feedback_form_email"
      expect(page).to have_field "feedback_form_message"
    end

    it "Fill ins and submits a valid form Form", js: true do
      fill_in "feedback_form_name", with: "Joe Smith"
      fill_in "feedback_form_email", with: "jsmith@university.edu"
      fill_in "feedback_form_message", with: "awesome site"
      click_button "Send"
      expect(page).to have_content(I18n.t("blacklight.feedback.confirmation"))
    end

    describe "It provides error messages", js: true do
      it "When the name field is not filled in" do
        fill_in "feedback_form_email", with: "foo@university.edu"
        fill_in "feedback_form_message", with: "awesome site"
        click_button "Send"
        expect(page).to have_content(I18n.t("blacklight.feedback.error"))
        expect(page).to have_selector(".has-error")
      end
    end
  end

  context "when Princeton Community User has signed in" do
    let(:user) { FactoryBot.create(:user) }

    before { OmniAuth.config.test_mode = true }
    it "Populates Email Field" do
      sign_in user
      visit("/catalog/princeton-cv43nz62s")
      click_link "Login"
      click_link("Contact Us")
      expect(page).to have_field("feedback_form_email", with: "#{user.uid}@princeton.edu")
    end
  end
end
