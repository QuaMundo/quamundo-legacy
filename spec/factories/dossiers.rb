FactoryBot.define do
  factory :dossier do
    sequence(:name)  { |n| "Dossier No. #{n}" }
    description       { "Description of dossier #{name}" }
    content           { "Content of dossier #{name}" }
  end
end
