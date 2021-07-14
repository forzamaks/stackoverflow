shared_examples_for 'API Authorizable' do
  context 'unauthorized' do
    it 'returns 401 status if there is not acess_token' do
      do_request(method, api_path, headers: headers)
      expect(response.status).to eq 401 
    end
    it 'returns 401 status if access_token is invalid' do
      do_request(method, api_path, headers: headers, params: { access_token: '1234' })
      expect(response.status).to eq 401 
    end
  end
end

shared_examples_for 'Success requestable' do
  it 'return success status' do
    expect(response).to be_successful
  end
end

shared_examples 'Public fields returnable' do
  it 'return all public fields' do
    items.each do |item|
      expect(resource_response[item]).to eq resource.send(item).as_json
    end
  end
end


shared_examples 'Resource count returnable' do
  it 'returns list of resources' do
    expect(resource_response.size).to eq resource.size
  end
end