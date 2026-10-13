FactoryBot.define do
  factory :user do
    sequence(:username) { |n| "username#{srand}" }
    email do |user|
      "#{user.username}@princeton.edu"
    end
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
