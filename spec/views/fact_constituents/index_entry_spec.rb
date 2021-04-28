# frozen_string_literal: true

RSpec.describe 'fact_constituents/index', type: :view do
  let(:constituent) do
    create(:fact_constituent,
           roles: ['role 1', 'role 2'])
  end
  let(:constituable)  { constituent.constituable }
  let(:fact)          { constituent.fact }
  let(:world)         { fact.world }

  before(:example) do
    # FIXME: `current_world` doesn't seem to be available, so work around ...
    controller.class.class_eval { include WorldAssociationController }
    allow(controller).to receive(:current_world).and_return(world)
  end

  context 'registered user' do
    include_context 'Session'

    context 'owning world' do
      let(:constituent) do
        create(:fact_constituent,
               roles: ['role 1', 'role 2'],
               user: user)
      end

      it 'shows a fact constituent index entry' do
        render(partial: 'fact_constituents/index_entry',
               locals: { index_entry: constituent })

        expect(rendered).to have_selector('li.index_entry')
        expect(rendered)
          .to have_selector('.index_entry_name', text: /#{constituable.name}/)
        expect(rendered).to match /#{world.name}/
        expect(rendered).to match /#{fact.name}/
        constituent.roles.each do |role|
          expect(rendered).to match /#{role}/
        end

        expect(rendered)
          .to have_link(href: polymorphic_path([world, constituable]))
        expect(rendered)
          .to have_link(
            href: edit_world_fact_path(world, fact)
          )
        expect(rendered)
          .to have_link(
            href: /^#{world_fact_path(world, fact)}/,
            id: /delete-.+/
          )
      end
    end

    context 'not owning world' do
      it 'does not show crud links with read permissions only' do
        Permission.create(world: world, user: user, permissions: :r)

        render(partial: 'fact_constituents/index_entry',
               locals: { index_entry: constituent })

        expect(rendered)
          .not_to have_link(
            href: edit_world_fact_path(world, fact)
          )
        expect(rendered)
          .not_to have_link(
            href: /^#{world_fact_path(world, fact)}/,
            id: /delete-.+/
          )
      end

      it 'shows crud links with read-write permissions' do
        Permission.create(world: world, user: user, permissions: :rw)

        render(partial: 'fact_constituents/index_entry',
               locals: { index_entry: constituent })

        expect(rendered)
          .to have_link(
            href: edit_world_fact_path(world, fact)
          )
        expect(rendered)
          .to have_link(
            href: /^#{world_fact_path(world, fact)}/,
            id: /delete-.+/
          )
      end
    end
  end

  context 'unregistered user with public readable world' do
    it 'does not show crud links' do
      Permission.create(world: world, permissions: :public)

      render(partial: 'fact_constituents/index_entry',
             locals: { index_entry: constituent })

      expect(rendered)
        .not_to have_link(
          href: edit_world_fact_path(world, fact)
        )
      expect(rendered)
        .not_to have_link(
          href: /^#{world_fact_path(world, fact)}/,
          id: /delete-.+/
        )
    end
  end
end
