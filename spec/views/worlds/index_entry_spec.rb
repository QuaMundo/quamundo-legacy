# frozen_string_literal: true

RSpec.describe 'worlds/index', type: :view do
  let(:world) { build(:world_with_facts, facts_count: 2) }

  context 'registered user' do
    include_context 'Session'

    context 'owning world' do
      let(:world) do
        world = build(:world_with_facts, facts_count: 2, user: user)
        # rubocop:disable Rails/SkipsModelValidations
        world.facts.first.update_attribute(:start_date, DateTime.new(1800, 1, 1))
        world.facts.last.update_attribute(:end_date, DateTime.new(2200, 12, 31))
        # rubocop:enable Rails/SkipsModelValidations
        world.save!
        world
      end

      it 'shows a world index entry' do
        render partial: 'worlds/index_entry', locals: { index_entry: world }

        expect(rendered).to have_selector('li.index_entry')
        expect(rendered)
          .to have_selector('.index_entry_name', text: /#{world.name}/)
        expect(rendered)
          .to have_selector('.index_entry_description', text: /#{world.description}/)
        expect(rendered).to match /Wed, 01 Jan 1800 00:00:00/
        expect(rendered).to match /Wed, 31 Dec 2200 00:00:00/
        # FIXME: Testing world stats missing

        expect(rendered).to have_link(href: world_path(world))
        expect(rendered).to have_link(href: edit_world_path(world))
        expect(rendered).to have_link(href: world_path(world), id: /delete-.+/)
      end
    end

    context 'not owning world' do
      it 'does not show crud links with read-only permissions' do
        Permission.create(world: world, user: user, permissions: :r)

        render partial: 'worlds/index_entry', locals: { index_entry: world }

        expect(rendered)
          .not_to have_link(href: edit_world_path(world))
        expect(rendered)
          .not_to have_link(href: world_path(world), title: 'delete')
      end

      it 'does show only edit link to user with rw permissions' do
        Permission.create(world: world, user: user, permissions: :rw)

        render partial: 'worlds/index_entry', locals: { index_entry: world }

        expect(rendered)
          .to have_link(href: edit_world_path(world))
        expect(rendered)
          .not_to have_link(href: world_path(world), title: 'delete')
      end
    end
  end

  context 'unregistered user' do
    it 'does not show crud links' do
      Permission.create(world: world, permissions: :public)

      render partial: 'worlds/index_entry', locals: { index_entry: world }

      expect(rendered)
        .not_to have_link(href: edit_world_path(world))
      expect(rendered)
        .not_to have_link(href: world_path(world), title: 'delete')
    end
  end
end
