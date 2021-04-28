# frozen_string_literal: true

RSpec.describe 'Dossiers', type: :request do
  let(:item)      { create(:item_with_dossiers, dossiers_count: 1) }
  let(:dossier)   { item.dossiers.first }
  let(:world)     { item.world }

  context 'with unregistered user' do
    context 'with non public world' do
      it 'redirects to worlds path on access' do
        post world_item_dossiers_path(world, item)
        expect(response).to redirect_to new_user_session_path

        get new_world_item_dossier_path(world, item)
        expect(response).to redirect_to new_user_session_path

        get edit_dossier_path(dossier)
        expect(response).to redirect_to new_user_session_path

        put dossier_path(dossier)
        expect(response).to redirect_to new_user_session_path

        get dossier_path(dossier)
        expect(response).to redirect_to worlds_path

        delete dossier_path(dossier)
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'with public world' do
      before(:example) do
        Permission.create(world: world, permissions: :public)
      end

      it 'shows only show and index actions' do
        post world_item_dossiers_path(world, item)
        expect(response).to redirect_to new_user_session_path

        get new_world_item_dossier_path(world, item)
        expect(response).to redirect_to new_user_session_path

        get edit_dossier_path(dossier)
        expect(response).to redirect_to new_user_session_path

        put dossier_path(dossier)
        expect(response).to redirect_to new_user_session_path

        get dossier_path(dossier)
        expect(response).to have_http_status(:success)

        delete dossier_path(dossier)
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  context 'with registerd user' do
    include_context 'Session'

    context 'owning world' do
      let(:item)    { create(:item, user: user) }

      it 'shows all actions' do
        post world_item_dossiers_path(world, item, params: sample_params)
        expect(response).to redirect_to(dossier_path(item.dossiers.last))

        get new_world_item_dossier_path(world, item, params: sample_params)
        expect(response).to have_http_status(:success)

        get edit_dossier_path(dossier)
        expect(response).to have_http_status(:success)

        put dossier_path(dossier, params: sample_params)
        expect(response).to redirect_to dossier_path(dossier)

        get dossier_path(dossier)
        expect(response).to have_http_status(:success)

        delete dossier_path(dossier)
        expect(response).to redirect_to world_item_path(world, item)
      end
    end

    context 'not owning world' do
      context 'with no permissions' do
        it 'redirects to worlds path' do
          post world_item_dossiers_path(world, item, params: sample_params)
          expect(response).to redirect_to worlds_path

          get new_world_item_dossier_path(world, item, params: sample_params)
          expect(response).to redirect_to worlds_path

          get edit_dossier_path(dossier)
          expect(response).to redirect_to worlds_path

          put dossier_path(dossier, params: sample_params)
          expect(response).to redirect_to worlds_path

          get dossier_path(dossier)
          expect(response).to redirect_to worlds_path

          delete dossier_path(dossier)
          expect(response).to redirect_to worlds_path
        end
      end

      context 'with read permissions' do
        before(:example) do
          Permission.create(user: user, world: world, permissions: :r)
        end

        it 'shows only show and index actions' do
          post world_item_dossiers_path(world, item, params: sample_params)
          expect(response).to redirect_to worlds_path

          get new_world_item_dossier_path(world, item, params: sample_params)
          expect(response).to redirect_to worlds_path

          get edit_dossier_path(dossier)
          expect(response).to redirect_to worlds_path

          put dossier_path(dossier, params: sample_params)
          expect(response).to redirect_to worlds_path

          get dossier_path(dossier)
          expect(response).to have_http_status(:success)

          delete dossier_path(dossier)
          expect(response).to redirect_to worlds_path
        end
      end

      context 'with read-write permissions' do
        before(:example) do
          Permission.create(user: user, world: world, permissions: :rw)
        end

        it 'shows all actions' do
          post world_item_dossiers_path(world, item, params: sample_params)
          expect(response).to redirect_to(dossier_path(item.dossiers.last))

          get new_world_item_dossier_path(world, item, params: sample_params)
          expect(response).to have_http_status(:success)

          get edit_dossier_path(dossier)
          expect(response).to have_http_status(:success)

          put dossier_path(dossier, params: sample_params)
          dossier.reload
          expect(response).to redirect_to(dossier_path(dossier))

          get dossier_path(dossier)
          expect(response).to have_http_status(:success)

          delete dossier_path(dossier)
          expect(response).to redirect_to(world_item_path(world, item))
        end
      end
    end
  end

  def sample_params
    {
      dossier: {
        name: 'Dossier',
        content: 'Bla',
        dossierable_type: 'Item',
        dossierable_id: item.id
      }
    }
  end
end
