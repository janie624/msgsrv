FactoryGirl.define do
  factory :roles_user

  factory :user do
    sequence(:first_name) {|n| "user#{n}"}
    last_name 'user'
    email { "#{first_name}@#{last_name}.com".downcase }
    password 'password'
    password_confirmation 'password'
    association :profile, factory: :profile, :user_id => :id
    association :role, :factory => :student_role
    association :team
    association :school

    factory :owner do
      last_name 'owner'
      association :role, :factory => :owner_role
      school nil
      team nil
    end

    factory :admin do
      last_name 'admin'
      association :role, :factory => :admin_role
      team nil
    end

    factory :coach do
      last_name 'coach'
      association :role, :factory => :coach_role
    end

    factory :student do
      last_name 'student'
    end

    factory :user_with_phone do
      association :profile, factory: :profile_with_phone, :user_id => :id
    end

  end
end
