FactoryBot.define do
  factory :answer do
    body { "AnswerText" }

    trait :invalid do
      body { nil }
    end

    trait :with_file do
      after :create do |answer|
        answer.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: 'rails_helper.rb')

        def answer.filename
          files[0].filename.to_s
        end
      end
    end
  end
end
