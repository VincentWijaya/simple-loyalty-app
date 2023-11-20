# spec/factories/tiers.rb

FactoryBot.define do
  factory :tier do
    sequence(:id)
    name { 'Bronze' }
    minSpent { 0 }
  end
end
