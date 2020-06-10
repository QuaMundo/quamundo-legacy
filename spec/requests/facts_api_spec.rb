RSpec.describe 'Facts API', type: :request do
  context 'with unregistered user' do
    let(:fact_1)    { create(:fact) }
    let(:world)     { fact_1.world }
    let!(:fact_2)    { create(:fact, world: world) }

    context 'with non public world' do
      it 'results to unprocessable entity' do
        # index action
        get world_facts_path(world, format: :json)
        expect(response).to have_http_status(422)

        # show action
        get world_fact_path(world, fact_1, format: :json)
        expect(response).to have_http_status(422)
      end
    end

    context 'with public world' do
      before(:example) do
        Permission.create(world: world, permissions: :public)
      end

      it 'returns data as json' do
        # index
        get world_facts_path(world, format: :json)
        expect(response).to have_http_status(:success)
        expect(json_of(response)).to include(
          include('id' => fact_1.id),
          include('id' => fact_2.id)
        )
        
        # show action
        get world_fact_path(world, fact_1, format: :json)
        expect(response).to have_http_status(:success)
        expect(json_of(response)).to include('id' => fact_1.id)
      end
    end
  end

  context 'with registerd user' do
    include_context 'Session'

    context 'owning world' do
      let(:fact_1)      { create(:fact, user: user) }
      let(:world)       { fact_1.world }
      let!(:fact_2)     { create(:fact_with_constituents, world: world, user: user) }
      let(:constituent) { fact_2.fact_constituents.first }

      it 'returns data as json' do
        # index action
        get world_facts_path(world, format: :json)
        expect(response).to have_http_status(:success)
        expect(json_of(response)).to include(
          include('id' => fact_1.id),
          include('id' => fact_2.id)
        )

        # index with constituent
        get world_facts_path(
          world,
          format: :json,
          inventory: { id: constituent.constituable_id,
                       type: constituent.constituable_type }
        )
        expect(response).to have_http_status(:success)
        expect(json_of(response)).to include(include 'id' => fact_2.id)
        expect(json_of(response)).not_to include(include 'id' => fact_1.id)

        # show action
        get world_fact_path(world, fact_1, format: :json)
        expect(response).to have_http_status(:success)
        expect(json_of(response)).to include('id' => fact_1.id)
      end
    end

    context 'not owning world' do
      let(:fact_1)      { create(:fact) }
      let(:world)       { fact_1.world }
      let!(:fact_2)     { create(:fact_with_constituents, world: world) }
      let(:constituent) { fact_2.fact_constituents.first }

      context 'with no permissions' do
        it 'results to unprocessable entity' do
          # index action
          get world_facts_path(world, format: :json)
          expect(response).to have_http_status(422)

          # show action
          get world_fact_path(world, fact_1, format: :json)
          expect(response).to have_http_status(422)
        end
      end

      context 'with read permissions' do
        before(:example) do
          Permission.create(user: user, world: world, permissions: :r)
        end

        it 'returns data as json' do
          # index action
          get world_facts_path(world, format: :json)
          expect(response).to have_http_status(:success)
          expect(json_of(response)).to include(
            include('id' => fact_1.id),
            include('id' => fact_2.id)
          )

          # index with constituent
          get world_facts_path(
            world,
            format: :json,
            inventory: { id: constituent.constituable_id,
                         type: constituent.constituable_type }
          )
          expect(response).to have_http_status(:success)
          expect(json_of(response)).to include(include 'id' => fact_2.id)
          expect(json_of(response)).not_to include(include 'id' => fact_1.id)

          # show action
          get world_fact_path(world, fact_1, format: :json)
          expect(response).to have_http_status(:success)
          expect(json_of(response)).to include('id' => fact_1.id)
        end
      end

      context 'with read-write permissions'
    end
  end

  def json_of(data)
    JSON.parse(data.body)
  end
end
