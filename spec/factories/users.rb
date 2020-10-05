FactoryBot.define do
  factory :user do
    sequence(:username) { |n| "username#{srand}" }
    sequence(:email) { |n| "email-#{srand}@princeton.edu" }
    provider { 'cas' }
    password { 'foobarfoo' }
    uid do |user|
      user.username
    end

    factory :admin do
      username { 'admin123' }
    end
  end
end
