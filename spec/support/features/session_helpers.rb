# frozen_string_literal: true

module Features
  # Provides methods for login and logout within Feature Tests
  module SessionHelpers
    # Regular login
    def login_as(user)
      user.reload # because the user isn't re-queried via Warden
      super(user, scope: :user, run_callbacks: false)
    end

    # Regular logout
    def logout(user = :user)
      super(user)
    end

    # Poltergeist-friendly sign-up
    # Use this in feature tests
    def sign_up_with(email, password)
      Capybara.exact = true
      visit new_user_registration_path
      fill_in "Email", with: email
      fill_in "Password", with: password
      fill_in "Password confirmation", with: password
      click_button "Sign up"
    end

    # Poltergeist-friendly sign-in
    # Use this in feature tests
    def sign_in(who = :user)
      user = if who.instance_of?(User)
               who.username
      else
               FactoryBot.create(:user).username
      end
      OmniAuth.config.mock_auth[:openid_connect] = OmniAuth::AuthHash.new(
        {
          "provider" => :openid_connect,
          "uid" => "#{user}@princeton.edu",
          "info" => {},
          "credentials" => {
            "id_token" => "secret",
            "token" => "secret",
            "refresh_token" => nil,
            "expires_in" => 4489,
            "scope" => "email openid profile"
          },
          "extra" => {
            "raw_info" => {
              "sub" => "",
              "preferred_username" => "#{user}@princeton.edu"
            }
          }
        })
      visit user_openid_connect_omniauth_authorize_path
    end
  end
end
