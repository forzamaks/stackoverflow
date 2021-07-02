FactoryBot.define do
  factory :answer do
    body { "AnswerText" }

    trait :invalid do
      body { nil }
    end
  end
end
