# frozen_string_literal: true

# FIXME: Do some more testing on the svg timelines ...
RSpec.describe 'Rendering fact timeline', type: :system, js: true do
  include_context 'Session'

  let(:world)   { create(:world, user: user) }
  let(:now)     { DateTime.current }
  let(:early)   { now - 6.months }
  let(:late)    { now + 6.months }

  context 'in a world without facts' do
    it 'draws no timeline at all' do
      visit(world_facts_path(world))
      expect(page).not_to have_selector('div.simple-timeline')
      expect(page).not_to have_selector('svg.simple-timeline')
      expect(page).not_to have_selector('svg')
    end
  end

  context 'in a world with one fact' do
    it 'does not draw a timeline with open fact' do
      fact = create(:fact, world: world)
      visit(world_fact_path(world, fact))
      expect(page).not_to have_selector('svg.simple-timeline')
      expect(page).not_to have_selector('rect.fact')
    end

    it 'does not draw a timeline with beginning fact' do
      fact = create(:fact, world: world, start_date: early)
      visit(world_fact_path(world, fact))
      expect(page).not_to have_selector('svg.simple-timeline')
    end

    it 'does not draw a timeline with ending fact' do
      fact = create(:fact, world: world, end_date: late)
      visit(world_fact_path(world, fact))
      expect(page).not_to have_selector('svg.simple-timeline')
    end

    it 'draws a timeline with ranged fact' do
      fact = create(:fact, world: world, start_date: early, end_date: late)
      visit(world_fact_path(world, fact))
      expect(page).to have_selector('svg.simple-timeline')
      expect(page).to have_selector('rect.fact.ranged-fact', count: 1)
    end
  end

  context 'in a world with two or more facts' do
    context 'with one fact open' do
      before(:example) { world.facts.create(name: 'fact').save! }

      it 'renders second ranged fact' do
        fact = create(:fact, world: world, start_date: early, end_date: late)
        visit(world_fact_path(world, fact))
        expect(page).to have_selector('svg.simple-timeline')
        expect(page).to have_selector('rect.fact.ranged-fact')
      end

      it 'does not render second open fact' do
        fact = create(:fact, world: world)
        visit(world_fact_path(world, fact))
        expect(page).not_to have_selector('svg.simple-timeline')
        expect(page).not_to have_selector('rect.fact')
      end

      it 'does not render second beginning fact' do
        fact = create(:fact, world: world, start_date: now)
        visit(world_fact_path(world, fact))
        expect(page).not_to have_selector('svg.simple-timeline')
        expect(page).not_to have_selector('rect.fact')
      end

      it 'does not render second ending fact' do
        fact = create(:fact, world: world, end_date: now)
        visit(world_fact_path(world, fact))
        expect(page).not_to have_selector('svg.simple-timeline')
        expect(page).not_to have_selector('rect.fact')
      end
    end

    context 'with one fact only beginning' do
      before(:example) do
        world.facts.create(
          name: 'fact',
          start_date: now
        ).save!
      end

      it 'does not render second open fact' do
        fact = create(:fact, world: world)
        visit(world_fact_path(world, fact))
        expect(page).not_to have_selector('svg.simple-timeline')
        expect(page).not_to have_selector('rect.fact')
      end

      it 'does not render second beginning fact with equal date' do
        fact = create(:fact, world: world, start_date: now)
        visit(world_fact_path(world, fact))
        expect(page).not_to have_selector('svg.simple-timeline')
        expect(page).not_to have_selector('rect.fact')
      end

      it 'renders second beginning fact with earlier date' do
        fact = create(:fact, world: world, start_date: early)
        visit(world_fact_path(world, fact))
        expect(page).to have_selector('svg.simple-timeline')
        expect(page).to have_selector('rect.fact')
      end

      it 'renders second beginning fact with later date' do
        fact = create(:fact, world: world, start_date: late)
        visit(world_fact_path(world, fact))
        expect(page).to have_selector('svg.simple-timeline')
        expect(page).to have_selector('polygon.fact')
      end
    end

    context 'with one fact only ending' do
      before(:example) do
        world.facts.create(
          name: 'fact',
          end_date: now
        ).save!
      end

      it 'does not render second open fact' do
        fact = create(:fact, world: world)
        visit(world_fact_path(world, fact))
        expect(page).not_to have_selector('svg.simple-timeline')
        expect(page).not_to have_selector('rect.fact')
      end

      it 'does not render second ending fact with equal date' do
        fact = create(:fact, world: world, end_date: now)
        visit(world_fact_path(world, fact))
        expect(page).not_to have_selector('svg.simple-timeline')
        expect(page).not_to have_selector('rect.fact')
      end

      it 'renders second ending fact with earlier date' do
        fact = create(:fact, world: world, end_date: early)
        visit(world_fact_path(world, fact))
        expect(page).to have_selector('svg.simple-timeline')
        expect(page).to have_selector('polygon.fact')
      end

      it 'renders second ending fact with later date' do
        fact = create(:fact, world: world, end_date: late)
        visit(world_fact_path(world, fact))
        expect(page).to have_selector('svg.simple-timeline')
        expect(page).to have_selector('rect.fact')
      end
    end

    context 'with one fact ranged' do
      before(:example) do
        world.facts.create(
          name: 'fact',
          start_date: early,
          end_date: late
        ).save!
      end

      it 'does not render a second open fact' do
        fact = create(:fact, world: world)
        visit(world_fact_path(world, fact))
        expect(page).not_to have_selector('svg.simple-timeline')
        expect(page).not_to have_selector('rect.fact')
      end

      it 'renders a second beginning only fact' do
        fact = create(:fact, world: world, start_date: early)
        visit(world_fact_path(world, fact))
        expect(page).to have_selector('svg.simple-timeline')
        expect(page).to have_selector('rect.fact')
      end

      it 'renders a second ending only fact' do
        fact = create(:fact, world: world, end_date: late)
        visit(world_fact_path(world, fact))
        expect(page).to have_selector('svg.simple-timeline')
        expect(page).to have_selector('rect.fact')
      end

      it 'renders a second ranged fact' do
        fact = create(:fact, world: world, start_date: early, end_date: late)
        visit(world_fact_path(world, fact))
        expect(page).to have_selector('svg.simple-timeline')
        expect(page).to have_selector('rect.fact')
      end
    end
  end
end
