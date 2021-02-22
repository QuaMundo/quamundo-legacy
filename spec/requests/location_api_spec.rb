RSpec.describe 'Location AIP', type: :request do
  context 'with unregistered user' do
    let(:world)       { create(:world_with_locations, locations_count: 3) }
    let(:location)    { world.locations.first }
    let(:location_2)  { world.locations.second }
    let(:location_3)  { world.locations.last }
    let(:fact)        { create(:fact, world: world) }

    context 'with non public world' do
      it 'results to unprocessable entity' do
        # index action
        get world_locations_path(world, format: :json)
        expect(response).to have_http_status(422)

        # show action
        get world_location_path(world, location, format: :json)
        expect(response).to have_http_status(422)
      end
    end

    context 'with public world' do
      before(:example) do
        Permission.create(world: world, permissions: :public)
      end

      it 'returns data as json' do
        # index action
        get world_locations_path(world, format: :json)
        expect(response).to have_http_status(:success)
        world.locations.each do |l|
          expect(json_of(response)).to include(include(
            'id' => l.id,
            'url' => world_location_path(l.world, l),
            'lat' => l.lat,
            'lon' => l.lon
          ))
        end

        # index with fact
        fc_1 = create(:fact_constituent, fact: fact, constituable: location)
        fc_2 = create(:fact_constituent, fact: fact, constituable: location_2)
        get world_locations_path(world, format: :json, fact: fact)
        expect(response).to have_http_status(:success)
        expect(json_of(response)).to include(include('id' => location.id))
        expect(json_of(response)).to include(include('id' => location_2.id))
        expect(json_of(response)).not_to include(include('id' => location_3.id))

        # show action
        get world_location_path(world, location, format: :json)
        expect(response).to have_http_status(:success)
        expect(json_of(response)).to include('id' => location.id)
      end
    end
  end

  context 'with registered user' do
    include_context 'Session'

    context 'owning world' do
      let(:world)     { create(
        :world_with_locations, locations_count: 3, user: user
      ) }
      let(:location)  { world.locations.first }
      let(:location_2)  { world.locations.second }
      let(:location_3)  { world.locations.last }
      let(:fact)        { create(:fact, world: world) }

      it 'returns data as jsons' do
        # index action
        get world_locations_path(world, format: :json)
        expect(response).to have_http_status(:success)
        world.locations.each do |l|
          expect(json_of(response)).to include(
            include('id' => l.id, 'url' => world_location_path(world, l))
          )
        end

        # index with fact
        fc_1 = create(:fact_constituent, fact: fact, constituable: location)
        fc_2 = create(:fact_constituent, fact: fact, constituable: location_2)
        get world_locations_path(world, fact: fact, format: :json)
        expect(response).to have_http_status(:success)
        expect(json_of(response)).to include(include('id' => location.id))
        expect(json_of(response)).to include(include('id' => location_2.id))
        expect(json_of(response)).not_to include(include('id' => location_3.id))

        # show action
        get world_location_path(world, location, format: :json)
        expect(response).to have_http_status(:success)
        expect(json_of(response)).to include('id' => location.id)
      end
    end

    context 'not owning world' do
      let(:world)     { create(:world_with_locations, locations_count: 3) }
      let(:location)  { world.locations.first }
      let(:location_2)  { world.locations.second }
      let(:location_3)  { world.locations.last }
      let(:fact)        { create(:fact, world: world) }

      context 'with no permissions' do
        it 'results to unprocessable entity' do
          # index action
          get world_locations_path(world, format: :json)
          expect(response).to have_http_status(422)

          # show action
          get world_location_path(world, location, format: :json)
          expect(response).to have_http_status(422)
        end
      end

      context 'with read permissions' do
        before(:example) do
          Permission.create(user: user, world: world, permissions: :r)
        end

        it 'returns data as json' do
          # index action
          get world_locations_path(world, format: :json)
          expect(response).to have_http_status(:success)
          world.locations.each do |l|
            expect(json_of(response)).to include(
              include('id' => l.id, 'url' => world_location_path(world, l))
            )
          end

          # index with fact
          fc_1 = create(:fact_constituent, fact: fact, constituable: location)
          fc_2 = create(:fact_constituent, fact: fact, constituable: location_2)
          get world_locations_path(world, format: :json, fact: fact)
          expect(response).to have_http_status(:success)
          expect(json_of(response)).to include(include('id' => location.id))
          expect(json_of(response)).to include(include('id' => location_2.id))
          expect(json_of(response)).not_to include(include('id' => location_3.id))

          # show action
          get world_location_path(world, location, format: :json)
          expect(response).to have_http_status(:success)
          expect(json_of(response)).to include('id' => location.id)
        end
      end

      context 'with read-write permissions'
    end
  end
end
