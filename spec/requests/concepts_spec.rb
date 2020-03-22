RSpec.describe 'Concepts', type: :request do
  let(:concept)    { create(:concept) }
  let(:world)     { concept.world }

  context 'with unregistered user' do
    context 'with non public world' do
      it 'redirects to worlds path on access' do
        post world_concepts_path(world)
        expect(response).to redirect_to new_user_session_path

        get new_world_concept_path(world)
        expect(response).to redirect_to new_user_session_path

        get edit_world_concept_path(world, concept)
        expect(response).to redirect_to new_user_session_path

        put world_concept_path(world, concept)
        expect(response).to redirect_to new_user_session_path

        get world_concepts_path(world)
        expect(response).to redirect_to worlds_path

        get world_concept_path(world, concept)
        expect(response).to redirect_to worlds_path

        delete world_concept_path(world, concept)
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'with public world' do
      before(:example) do
        Permission.create(world: world, permissions: :public)
      end

      it 'shows only show and index actions' do
        post world_concepts_path(world)
        expect(response).to redirect_to new_user_session_path

        get new_world_concept_path(world)
        expect(response).to redirect_to new_user_session_path

        get edit_world_concept_path(world, concept)
        expect(response).to redirect_to new_user_session_path

        put world_concept_path(world, concept)
        expect(response).to redirect_to new_user_session_path

        get world_concepts_path(world)
        expect(response).to have_http_status(:success)

        get world_concept_path(world, concept)
        expect(response).to have_http_status(:success)

        delete world_concept_path(world, concept)
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  context 'with registerd user' do
    include_context 'Session'

    context 'owning world' do
      let(:concept)    { create(:concept, user: user) }

      it 'shows all actions' do
        post world_concepts_path(world, params: sample_params)
        expect(response).to have_http_status(:success)

        get new_world_concept_path(world)
        expect(response).to have_http_status(:success)

        get edit_world_concept_path(world, concept)
        expect(response).to have_http_status(:success)

        put world_concept_path(world, concept, params: sample_params)
        expect(response).to redirect_to world_concept_path(world, concept)

        get world_concepts_path(world)
        expect(response).to have_http_status(:success)

        get world_concept_path(world, concept)
        expect(response).to have_http_status(:success)

        delete world_concept_path(world, concept)
        expect(response).to redirect_to world_concepts_path(world)
      end
    end

    context 'not owning world' do
      context 'with no permissions' do
        it 'redirects to worlds path' do
          post world_concepts_path(world, params: sample_params)
          expect(response).to redirect_to worlds_path

          get new_world_concept_path(world)
          expect(response).to redirect_to worlds_path

          get edit_world_concept_path(world, concept)
          expect(response).to redirect_to worlds_path

          put world_concept_path(world, concept)
          expect(response).to redirect_to worlds_path

          get world_concepts_path(world)
          expect(response).to redirect_to worlds_path

          get world_concept_path(world, concept)
          expect(response).to redirect_to worlds_path

          delete world_concept_path(world, concept)
          expect(response).to redirect_to worlds_path
        end
      end

      context 'with read permissions' do
        before(:example) do
          Permission.create(user: user, world: world, permissions: :r)
        end

        it 'shows only show and index actions' do
          post world_concepts_path(world, params: sample_params)
          expect(response).to redirect_to worlds_path

          get new_world_concept_path(world)
          expect(response).to redirect_to worlds_path

          get edit_world_concept_path(world, concept)
          expect(response).to redirect_to worlds_path

          put world_concept_path(world, concept)
          expect(response).to redirect_to worlds_path

          get world_concepts_path(world)
          expect(response).to have_http_status(:success)

          get world_concept_path(world, concept)
          expect(response).to have_http_status(:success)

          delete world_concept_path(world, concept)
          expect(response).to redirect_to worlds_path
        end
      end

      context 'with read-write permissions' do
        before(:example) do
          Permission.create(user: user, world: world, permissions: :rw)
        end

        it 'shows all actions' do
          post world_concepts_path(world, params: sample_params)
          expect(response).to have_http_status(:success)

          get new_world_concept_path(world)
          expect(response).to have_http_status(:success)

          get edit_world_concept_path(world, concept)
          expect(response).to have_http_status(:success)

          put world_concept_path(world, concept, params: sample_params)
          expect(response).to redirect_to world_concept_path(world, concept)

          get world_concepts_path(world)
          expect(response).to have_http_status(:success)

          get world_concept_path(world, concept)
          expect(response).to have_http_status(:success)

          delete world_concept_path(world, concept)
          expect(response).to redirect_to world_concepts_path(world)
        end
      end
    end
  end

  def sample_params
    {
      concept: {
        tag_attributes: {id: nil, tagset: 'tag'}
      }
    }
  end
end


