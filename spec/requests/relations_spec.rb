RSpec.describe 'Relations', type: :request do
  let(:fact)      { create(:fact) }
  let(:relation)  { create(:relation, fact: fact) }
  let(:world)     { fact.world }

  context 'with unregistered user' do
    context 'with non public world' do
      it 'redirects to worlds path on access' do
        post world_fact_relations_path(world, fact)
        expect(response).to redirect_to new_user_session_path

        get new_world_fact_relation_path(world, fact)
        expect(response).to redirect_to new_user_session_path

        get edit_world_fact_relation_path(world, fact, relation)
        expect(response).to redirect_to new_user_session_path

        put world_fact_relation_path(world, fact, relation)
        expect(response).to redirect_to new_user_session_path

        get world_fact_relations_path(world, fact)
        expect(response).to redirect_to worlds_path

        get world_fact_relation_path(world, fact, relation)
        expect(response).to redirect_to worlds_path

        delete world_fact_relation_path(world, fact, relation)
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'with public world' do
      before(:example) do
        Permission.create(world: world, permissions: :public)
      end

      it 'shows only show and index actions' do
        post world_fact_relations_path(world, fact)
        expect(response).to redirect_to new_user_session_path

        get new_world_fact_relation_path(world, fact)
        expect(response).to redirect_to new_user_session_path

        get edit_world_fact_relation_path(world, fact, relation)
        expect(response).to redirect_to new_user_session_path

        put world_fact_relation_path(world, fact, relation)
        expect(response).to redirect_to new_user_session_path

        get world_fact_relations_path(world, fact)
        expect(response).to have_http_status(:success)

        get world_fact_relation_path(world, fact, relation)
        expect(response).to have_http_status(:success)

        delete world_fact_relation_path(world, fact, relation)
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  context 'with registerd user' do
    include_context 'Session'

    context 'owning world' do
      let(:fact)    { create(:fact, user: user) }

      it 'shows all actions' do
        post world_fact_relations_path(world, fact, params: sample_params)
        new_relation = Relation.last
        expect(response)
          .to redirect_to(world_fact_relation_path(world, fact, new_relation))

        get new_world_fact_relation_path(world, fact)
        expect(response).to have_http_status(:success)

        get edit_world_fact_relation_path(world, fact, relation)
        expect(response).to have_http_status(:success)

        put world_fact_relation_path(
          world, fact, relation, params: sample_params
        )
        expect(response)
          .to redirect_to world_fact_relation_path(world, fact, relation)

        get world_fact_relations_path(world, fact)
        expect(response).to have_http_status(:success)

        get world_fact_relation_path(world, fact, relation)
        expect(response).to have_http_status(:success)

        delete world_fact_relation_path(world, fact, relation)
        expect(response).to redirect_to world_fact_path(world, fact)
      end
    end

    context 'not owning world' do
      context 'with no permissions' do
        it 'redirects to worlds path' do
          post world_fact_relations_path(world, fact, params: sample_params)
          expect(response).to redirect_to worlds_path

          get new_world_fact_relation_path(world, fact)
          expect(response).to redirect_to worlds_path

          get edit_world_fact_relation_path(world, fact, relation)
          expect(response).to redirect_to worlds_path

          put world_fact_relation_path(world, fact, relation)
          expect(response).to redirect_to worlds_path

          get world_fact_relations_path(world, fact)
          expect(response).to redirect_to worlds_path

          get world_fact_relation_path(world, fact, relation)
          expect(response).to redirect_to worlds_path

          delete world_fact_relation_path(world, fact, relation)
          expect(response).to redirect_to worlds_path
        end
      end

      context 'with read permissions' do
        before(:example) do
          Permission.create(user: user, world: world, permissions: :r)
        end

        it 'shows only show and index actions' do
          post world_fact_relations_path(world, fact, params: sample_params)
          expect(response).to redirect_to worlds_path

          get new_world_fact_relation_path(world, fact)
          expect(response).to redirect_to worlds_path

          get edit_world_fact_relation_path(world, fact, relation)
          expect(response).to redirect_to worlds_path

          put world_fact_relation_path(world, fact, relation)
          expect(response).to redirect_to worlds_path

          get world_fact_relations_path(world, fact)
          expect(response).to have_http_status(:success)

          get world_fact_relation_path(world, fact, relation)
          expect(response).to have_http_status(:success)

          delete world_fact_relation_path(world, fact, relation)
          expect(response).to redirect_to worlds_path
        end
      end

      context 'with read-write permissions' do
        before(:example) do
          Permission.create(user: user, world: world, permissions: :rw)
        end

        it 'shows all actions' do
          post world_fact_relations_path(world, fact, params: sample_params)
          new_relation = Relation.last
          expect(response)
            .to redirect_to(world_fact_relation_path(world, fact, new_relation))

          get new_world_fact_relation_path(world, fact)
          expect(response).to have_http_status(:success)

          get edit_world_fact_relation_path(world, fact, relation)
          expect(response).to have_http_status(:success)

          put world_fact_relation_path(
            world, fact, relation, params: sample_params
          )
          expect(response)
            .to redirect_to world_fact_relation_path(world, fact, relation)

          get world_fact_relations_path(world, fact)
          expect(response).to have_http_status(:success)

          get world_fact_relation_path(world, fact, relation)
          expect(response).to have_http_status(:success)

          delete world_fact_relation_path(world, fact, relation)
          expect(response).to redirect_to world_fact_path(world, fact)
        end
      end
    end
  end

  def sample_params
    {
      relation: {
        name: 'Relation',
        fact_id: fact.id
      }
    }
  end
end



