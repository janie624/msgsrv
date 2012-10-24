FactoryGirl.define do
  factory :recipient, :class => Message::Recipient do
    association :user, :factory => :user_with_phone
  end

end