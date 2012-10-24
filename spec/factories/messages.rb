FactoryGirl.define do
  factory :message do
    body { Faker::Lorem.sentence }
    subject { Faker::Lorem.sentence(3) }
    association :sender, :factory => :coach
  end

end