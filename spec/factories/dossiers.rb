FactoryBot.define do
  factory :dossier do
    sequence(:title)  { |n| "Dossier No. #{n}" }
    description       { "Description of dossier #{title}" }
    content           { "Content of dossier #{title}" }
  end
end
