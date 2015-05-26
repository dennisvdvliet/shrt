require 'rails_helper'

# Smoke test to make sure we follow the specs in the gist
# https://gist.github.com/vasc/37f36488fc9e959dcaf8

describe 'POST /shorten' do
  context 'valid input' do
    it 'returns a 201 after creating a new link' do
      post "/shorten", {url: "http://smshunt.co", shortcode: "axaxax"}.to_json
      expect(response.status).to eq(201)
    end
  end
  context 'invalid input' do
    it 'returns a 400 if url parameter is missing' do
      post "/shorten", {shortcode: "axaxax"}.to_json
      expect(response.status).to eq(400)
    end

    it 'returns a 409 if shortcode is already used' do
      post "/shorten", {url: "http://smshunt.co", shortcode: "axaxax"}.to_json
      expect(response.status).to eq(409)

    end

    it 'returns a 422 if shortcode fails validation' do
      post "/shorten", {url: "http://smshunt.co", shortcode: "axaxaxaxax"}.to_json
      expect(response.status).to eq(422)
    end
  end
end

describe 'GET /:shortcode' do
  context 'non existent shortcode' do
    it 'returns a 404' do
      get "/axaxax404"
      expect(response.status).to eq(404)
    end
  end

  context 'existing shortcode' do
    it 'returns a 302 and redirects' do
      get "/axaxax"
      expect(response.status).to eq(302)
      expect(response).to redirect_to "http://smshunt.co"
    end
  end
end

describe 'GET /:shortcode/stats' do
  context 'non existent shortcode' do
    it 'returns a 404' do
      get "/axaxax404/stats"
      expect(response.status).to eq(404)
    end
  end

  context 'existing shortcode' do
    it 'returns a 200 and stats for shortcode' do
      get "/axaxax"
      expect(response.status).to eq(200)
      # validate output
    end
  end
end