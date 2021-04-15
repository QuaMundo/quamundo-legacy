# frozen_string_literal: true

RSpec.shared_examples 'inventory timelines', type: :system, js: true do
  let(:now)         { DateTime.current }
  let(:early)       { now - 1.year }
  let(:late)        { now + 1.year }
  let(:fact1) do
    create(:fact, world: subject.world,
                  end_date: now)
  end
  let(:fact2) do
    create(:fact, world: subject.world,
                  start_date: early,
                  end_date: late)
  end
  let(:fact3) { create(:fact, world: subject.world) }
  let(:fact_other) do
    create(:fact, world: subject.world,
                  start_date: now)
  end
  before(:example) do
    create(:fact_constituent, constituable: subject, fact: fact1)
    create(:fact_constituent, constituable: subject, fact: fact2)
    visit(polymorphic_path([subject.world, subject]))
  end

  it 'renders timeline with inventorys facts' do
    page.within('svg.simple-timeline') do
      expect(page).to have_selector('rect.fact', count: 2)
    end
  end
end
