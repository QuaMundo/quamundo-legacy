# frozen_string_literal: true

RSpec.describe 'relation_constituents/index', type: :view do
  let(:relation) do
    create(:relation_with_constituents,
           subjects_count: 1,
           relatives_count: 1,
           bidirectional: true)
  end
  let(:fact)          { relation.fact }
  let(:world)         { fact.world }

  before(:example) do
    # FIXME: `current_world` doesn't seem to be available, so work around ...
    controller.class.class_eval { include WorldAssociationController }
    allow(controller).to receive(:current_world).and_return(world)
  end

  context 'registered user' do
    include_context 'Session'

    context 'owning world' do
      let(:relation) do
        create(:relation_with_constituents,
               user: user,
               subjects_count: 1,
               relatives_count: 1,
               bidirectional: true)
      end
      context 'one direction (of relation)' do
        let(:index_entry)   { relation.subject_relative_relations.first }
        let(:subject)       do
          index_entry.subject.fact_constituent.constituable
        end
        let(:relative) do
          index_entry.relative.fact_constituent.constituable
        end

        it 'shows a relation constituent index entry', db_triggers: true do
          render(partial: 'relation_constituents/index_entry',
                 locals: { index_entry: index_entry })

          expect(rendered).to have_selector('li.index_entry')
          expect(rendered).to have_selector(
            '.index_entry_name',
            text: /#{subject.name}\s+#{index_entry.name}\s+#{relative.name}/
          )
          expect(rendered).to have_selector('.index_entry_description',
                                            text: relation.description)
          expect(rendered).to match /#{fact.name}/

          expect(rendered).to have_link(
            href: world_fact_relation_path(world, fact, relation)
          )
          expect(rendered).to have_link(
            href: edit_world_fact_relation_path(world, fact, relation)
          )
          expect(rendered)
            .to have_link(
              href: /^#{world_fact_relation_path(world, fact, relation)}/,
              id: /delete-.+/
            )
        end
      end

      context 'other direction (of relation)' do
        let(:index_entry)   { relation.subject_relative_relations.second }
        let(:subject)       do
          index_entry.subject.fact_constituent.constituable
        end
        let(:relative) do
          index_entry.relative.fact_constituent.constituable
        end

        it 'shows a relation constituent index entry', db_triggers: true do
          render(partial: 'relation_constituents/index_entry',
                 locals: { index_entry: index_entry })

          expect(rendered).to have_selector('li.index_entry')
          expect(rendered).to have_selector(
            '.index_entry_name',
            text: /#{subject.name}\s+#{index_entry.name}\s+#{relative.name}/
          )
          expect(rendered).to have_selector('.index_entry_description',
                                            text: relation.description)
          expect(rendered).to match /#{fact.name}/

          expect(rendered).to have_link(
            href: world_fact_relation_path(world, fact, relation)
          )
          expect(rendered).to have_link(
            href: edit_world_fact_relation_path(world, fact, relation)
          )
          expect(rendered)
            .to have_link(
              href: /^#{world_fact_relation_path(world, fact, relation)}/,
              id: /delete-.+/
            )
        end
      end
    end

    context 'not owning world' do
      let(:index_entry)   { relation.subject_relative_relations.second }
      let(:subject)       do
        index_entry.subject.fact_constituent.constituable
      end
      let(:relative) do
        index_entry.relative.fact_constituent.constituable
      end

      it 'does not show crud links with read permission only',
         db_triggers: true do
        Permission.create(world: world, user: user, permissions: :r)

        render(partial: 'relation_constituents/index_entry',
               locals: { index_entry: index_entry })

        expect(rendered).not_to have_link(
          href: edit_world_fact_relation_path(world, fact, relation)
        )
        expect(rendered).not_to have_link(
          href: /^#{world_fact_relation_path(world, fact, relation)}/,
          title: 'delete'
        )
      end

      it 'does show crud links with read-write permissions',
         db_triggers: true do
        Permission.create(world: world, user: user, permissions: :rw)

        render(partial: 'relation_constituents/index_entry',
               locals: { index_entry: index_entry })

        expect(rendered).to have_link(
          href: edit_world_fact_relation_path(world, fact, relation)
        )
        expect(rendered).to have_link(
          href: /^#{world_fact_relation_path(world, fact, relation)}/,
          title: 'delete'
        )
      end
    end
  end

  context 'unregistered user with public readable world' do
    it 'does not render crud links', db_triggers: true do
      Permission.create(world: world, permissions: :public)

      expect(rendered).not_to have_link(
        href: edit_world_fact_relation_path(world, fact, relation)
      )
      expect(rendered).not_to have_link(
        href: /^#{world_fact_relation_path(world, fact, relation)}/,
        title: 'delete'
      )
    end
  end
end
