# frozen_string_literal: true

require 'json'
require 'mini_magick'
require 'net/http'
require 'uri'
require 'stringex'
require 'yaml'

require './env_utils'

url = get_env_or_exit('COWORKERS_URL')
code = get_env_or_exit('COWORKERS_CODE')
user = get_env_or_exit('COWORKERS_USER')
password = get_env_or_exit('COWORKERS_PASSWORD')

def fetch_image(image_url, user, password, path)
  uri = URI(image_url)
  request = Net::HTTP::Get.new(uri)
  request.basic_auth(user, password)
  response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') { |http| http.request(request) }
  return unless response.is_a?(Net::HTTPSuccess)

  image = MiniMagick::Image.read(response.body)
  image.resize("300x300\>")
  image.write(path)
end

all_tags = []
parser = URI::Parser.new
uri = URI(url)
uri.query = URI.encode_www_form({
                                  xpage: 'plain',
                                  outputSyntax: 'plain',
                                  code: code
                                })
response = Net::HTTP.get_response(uri)
if response.is_a?(Net::HTTPSuccess)
  Dir['_coworkers/*.*'].each { |f| File.delete(f) }
  JSON.parse(response.body)['coworkers'].each do |json|
    next unless json['public_enable'] &&
                (%w[nomade fixe].include?(json['formule']) || json['id'] == 'AurelieKhalidi') &&
                json['_profile_picture']

    coworker = { 'name' => "#{json['first_name']} #{json['last_name']}", 'layout' => 'coworker' }
    slug = coworker['name'].to_url
    coworker['permalink'] = "coworkers/#{slug}"
    coworker['picture_extension'] = File.extname(json['avatar']).downcase
    %w[metier phone emailpro facebook linkedin viadeo pinterest].each do |item|
      coworker[item] = json[item.to_s] unless json[item.to_s].empty?
    end
    coworker['twitter'] = json['twitter'].gsub(%r{((https?://)?twitter\.com/|@)}, '') unless json['twitter'].empty?
    tags = json['_tags'].reject { |tag| tag.nil? || tag.empty? }
    all_tags += tags
    coworker['tags'] = tags unless tags.empty?

    puts coworker, slug

    File.open("_coworkers/#{slug}.md", 'w') do |f|
      f.write("#{coworker.to_yaml}---\n")
      { 'public_quiesttu': 'Qui es-tu?', 'public_quefaistu': 'Que fais-tu?',
        'public_pourquoicoworking': 'Pourquoi le coworking?' }.each do |key, question|
        f.write("\n## #{question}\n\n#{json[key.to_s]}\n") unless json[key.to_s].empty?
      end
    end

    fetch_image(parser.escape(json['_profile_picture']), user, password,
                "_coworkers/#{slug}#{coworker['picture_extension']}")
  end
else
  puts "Bad response: #{response}"
  exit(-1)
end

File.open('_data/coworker_tags.yml', 'w') do |f|
  f.write(all_tags.uniq.map { |tag| { 'name' => tag } }.to_yaml)
end
