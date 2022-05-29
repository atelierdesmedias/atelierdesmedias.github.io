# frozen_string_literal: true

require 'octokit'
require 'rbnacl'
require 'base64'

require './env_utils'

puts get_env_or_exit('BOBO')
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

secret = { name: 'BOBO', value: 'bonbon' }
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
