FactoryBot.define do
  factory :figure_ancestor do
    figure      { build(:figure) }
    ancestor    { build(:figure, world: figure.world) }
    name        { "Mother" }
  end
end
