FactoryBot.define do
  factory :link do
    name { "MyString" }
    url { 'https://google.ru'}

    trait :linkable do
      association :linkable, factory: :answer
    end

    trait :valid_gist do
      url { 'https://gist.github.com/forzamaks/766c7ed8386ba3298d416098663ae260' }
    end

    trait :invalid_gist do
      url { 'https://gist.github.com/forzamaks/' }
    end
  end
end
