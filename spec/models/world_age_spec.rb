# frozen_string_literal: true

RSpec.describe World, type: :model do
  context 'Age of world' do
    let(:world)         { create(:world) }
    let(:now)           { DateTime.current }
    let(:early)         { now - 6.months }
    let(:earlier)       { now - 1.year }
    let(:late)          { now + 6.months }
    let(:later)         { now + 1.year }

    # In this suite an 'open' fact is without start and end date,
    # a 'beginning' fact ist with only start_date set,
    # 'ending' fact has only end_date set
    # and 'ranged' fact has both set

    context 'without facts' do
      it 'has no beginning, end or age' do
        expect(world.facts).to be_empty
        expect(world.age).to be_nil
        expect(world.beginning).to be_nil
        expect(world.ending).to be_nil
      end
    end

    context 'with one fact' do
      it 'has no age with open fact' do
        create(:fact, world: world)
        expect(world.facts.count).to eq 1
        expect(world.age).to be_nil
        expect(world.beginning).to be_nil
        expect(world.ending).to be_nil
      end

      it 'has no age but beginning and ending with ending fact' do
        create(:fact, world: world, end_date: later)
        expect(world.facts.count).to eq 1
        expect(world.age).to be_nil
        expect(world.beginning).to eq later
        expect(world.ending).to eq later
      end

      it 'has no age but beginning with beginning fact' do
        create(:fact, world: world, start_date: earlier)
        expect(world.age).to be_nil
        expect(world.beginning).to eq earlier
        expect(world.ending).to eq earlier
      end

      it 'has age, beginning and ending with ranged fact' do
        create(:fact, world: world, start_date: earlier, end_date: later)
        expect(world.beginning).to eq earlier
        expect(world.ending).to eq later
        expect(world.age).to eq later.to_f - earlier.to_f
      end
    end

    context 'with two facts' do
      context 'both open' do
        it ' has no age, ending or beginning' do
          2.times { create(:fact, world: world) }
          expect(world.facts.count).to eq 2
          expect(world.beginning).to be_nil
          expect(world.ending).to be_nil
          expect(world.age).to be_nil
        end
      end

      context 'open and beginning' do
        it 'has no age but beginning and ending' do
          create(:fact, world: world)
          create(:fact, world: world, start_date: earlier)
          expect(world.beginning).to eq earlier
          expect(world.ending).to eq earlier
          expect(world.age).to be_nil
        end
      end

      context 'open and ending' do
        it 'has no age but ending' do
          create(:fact, world: world)
          create(:fact, world: world, end_date: later)
          expect(world.beginning).to eq later
          expect(world.ending).to eq later
          expect(world.age).to be_nil
        end
      end

      context 'open and range' do
        it 'has age, beginning and ending' do
          create(:fact, world: world)
          create(:fact, world: world, start_date: earlier, end_date: later)
          expect(world.beginning).to eq earlier
          expect(world.ending).to eq later
          expect(world.age).to eq later.to_f - earlier.to_f
        end
      end

      context 'both range' do
        it 'has beginning, ending and age with different ranges' do
          create(:fact, world: world, start_date: earlier, end_date: early)
          create(:fact, world: world, start_date: late, end_date: later)
          expect(world.beginning).to eq earlier
          expect(world.ending).to eq later
          expect(world.age).to eq later.to_f - earlier.to_f
        end

        it 'has beginning, ending and age with overlapping ranges' do
          create(:fact, world: world, start_date: earlier, end_date: late)
          create(:fact, world: world, start_date: early, end_date: later)
          expect(world.beginning).to eq earlier
          expect(world.ending).to eq later
          expect(world.age).to eq later.to_f - earlier.to_f
        end

        it 'has beginning, ending and age with containing ranges' do
          create(:fact, world: world, start_date: earlier, end_date: later)
          create(:fact, world: world, start_date: early, end_date: late)
          expect(world.beginning).to eq earlier
          expect(world.ending).to eq later
          expect(world.age).to eq later.to_f - earlier.to_f
        end
      end

      context 'range and beginning' do
        it 'has beginning, ending and age with beginning before range' do
          create(:fact, world: world, start_date: earlier)
          create(:fact, world: world, start_date: early, end_date: late)
          expect(world.beginning).to eq earlier
          expect(world.ending).to eq late
          expect(world.age).to eq late.to_f - earlier.to_f
        end

        it 'has beginning, ending and age with beginning in range' do
          create(:fact, world: world, start_date: now)
          create(:fact, world: world, start_date: early, end_date: late)
          expect(world.beginning).to eq early
          expect(world.ending).to eq late
          expect(world.age).to eq late.to_f - early.to_f
        end

        it 'has beginning, ending and age with beginning after range' do
          create(:fact, world: world, start_date: later)
          create(:fact, world: world, start_date: early, end_date: late)
          expect(world.beginning).to eq early
          expect(world.ending).to eq later
          expect(world.age).to eq later.to_f - early.to_f
        end
      end

      context 'range and ending' do
        it 'has beginning, ending and age with ending after range' do
          create(:fact, world: world, end_date: later)
          create(:fact, world: world, start_date: early, end_date: late)
          expect(world.beginning).to eq early
          expect(world.ending).to eq later
          expect(world.age).to eq later.to_f - early.to_f
        end

        it 'has beginning, ending and age with ending in range' do
          create(:fact, world: world, end_date: now)
          create(:fact, world: world, start_date: early, end_date: late)
          expect(world.beginning).to eq early
          expect(world.ending).to eq late
          expect(world.age).to eq late.to_f - early.to_f
        end

        it 'has beginning, ending and age with enging before range' do
          create(:fact, world: world, end_date: earlier)
          create(:fact, world: world, start_date: early, end_date: late)
          expect(world.beginning).to eq earlier
          expect(world.ending).to eq late
          expect(world.age).to eq late.to_f - earlier.to_f
        end
      end

      context 'beginning and ending' do
        it 'has beginning, ending and age with both beginning' do
          create(:fact, world: world, start_date: early)
          create(:fact, world: world, start_date: late)
          expect(world.beginning).to eq early
          expect(world.ending).to eq late
          expect(world.age).to eq late.to_f - early.to_f
        end

        it 'has beginning, ending and age with both ending' do
          create(:fact, world: world, end_date: early)
          create(:fact, world: world, end_date: late)
          expect(world.beginning).to eq early
          expect(world.ending).to eq late
          expect(world.age).to eq late.to_f - early.to_f
        end

        it 'has beginning, ending and age with ending before beginning' do
          create(:fact, world: world, end_date: early)
          create(:fact, world: world, start_date: late)
          expect(world.beginning).to eq early
          expect(world.ending).to eq late
          expect(world.age).to eq late.to_f - early.to_f
        end

        it 'has beginning, ending and age with beginning before ending' do
          create(:fact, world: world, end_date: late)
          create(:fact, world: world, start_date: early)
          expect(world.beginning).to eq early
          expect(world.ending).to eq late
          expect(world.age).to eq late.to_f - early.to_f
        end

        it 'has beginning, ending but no age with same beginning' do
          2.times { create(:fact, world: world, start_date: now) }
          expect(world.beginning).to eq now
          expect(world.ending).to eq now
          expect(world.age).to be_nil
        end

        it 'has beginning, ending but no age with same ending' do
          2.times { create(:fact, world: world, end_date: now) }
          expect(world.beginning).to eq now
          expect(world.ending).to eq now
          expect(world.age).to be_nil
        end

        it 'has beginning, ending but no age with equal ending and beginning' do
          create(:fact, world: world, start_date: now)
          create(:fact, world: world, end_date: now)
          expect(world.beginning).to eq now
          expect(world.ending).to eq now
          expect(world.age).to be_nil
        end
      end
    end
  end
end
