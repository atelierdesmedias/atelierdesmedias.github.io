# frozen_string_literal: true

require 'json'
require 'octokit'
require 'rbnacl'
require 'base64'

require './env_utils'

access_token = get_env_or_exit('FACEBOOK_TOKEN')
app_id = get_env_or_exit('FACEBOOK_APP_ID')
app_secret = get_env_or_exit('FACEBOOK_CLIENT_SECRET')

uri = URI('https://graph.facebook.com/oauth/access_token')
uri.query = URI.encode_www_form({
                                  grant_type: 'fb_exchange_token',
                                  client_id: app_id,
                                  client_secret: app_secret,
                                  fb_exchange_token: access_token
                                })

res = Net::HTTP.get_response(uri)
if res.is_a?(Net::HTTPSuccess)
  new_token = JSON.parse(res.body)['access_token']
else
  puts "Bad response: #{res}"
  exit(-1)
end

github_token = get_env_or_exit('GITHUB_TOKEN')

# Provide authentication credentials
client = Octokit::Client.new(access_token: github_token)

def create_box(public_key)
  b64_key = RbNaCl::PublicKey.new(Base64.decode64(public_key[:key]))
  {
    key_id: public_key[:key_id],
    box: RbNaCl::Boxes::Sealed.from_public_key(b64_key)
  }
end

repo = client.repo 'atelierdesmedias/atelierdesmedias.github.io'

secret = { name: 'FACEBOOK_TOKEN', value: new_token }
public_key = client.get_public_key(repo.id)
puts 'public key:', public_key, public_key[:key], public_key[:key_id]
box = create_box(public_key)
puts 'box:', box[:key_id], box[:box]
puts 'after'
encrypted = box[:box].encrypt(secret[:value])
encrypted_value = Base64.strict_encode64(encrypted)
puts 'encrypted_value:', encrypted_value
puts client.create_or_update_secret(
  repo.id, secret[:name],
  key_id: box[:key_id], encrypted_value: encrypted_value
)
puts client.last_response.status
