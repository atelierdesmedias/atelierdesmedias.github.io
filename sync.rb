# frozen_string_literal: true

require 'uri'
require 'net/http'
require 'json'
require 'yaml'
require 'stringex'

url = ENV['COWORKERS_URL']
if url.nil?
  puts 'Please set COWORKERS_URL'
  exit(-1)
end
code = ENV['COWORKERS_CODE']
if code.nil?
  puts 'Please set COWORKERS_CODE'
  exit(-1)
end
user = ENV['COWORKERS_USER']
if user.nil?
  puts 'Please set COWORKERS_USER'
  exit(-1)
end
password = ENV['COWORKERS_PASSWORD']
if password.nil?
  puts 'Please set COWORKERS_PASSWORD'
  exit(-1)
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
    next unless json['public_enable'] && %w[nomade fixe].include?(json['formule'])

    coworker = { 'name' => "#{json['first_name']} #{json['last_name']}", 'layout' => 'coworker' }
    slug = coworker['name'].to_url
    coworker['permalink'] = "coworkers/#{slug}"
    coworker['picture_extension'] = File.extname(json['avatar']).downcase
    %w[metier phone emailpro facebook twitter linkedin viadeo pinterest].each do |item|
      coworker[item] = json[item.to_s] unless json[item.to_s].empty?
    end
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

    # Fetch the image
    uri = URI(parser.escape(json['_profile_picture']))
    request = Net::HTTP::Get.new(uri)
    request.basic_auth(user, password)
    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') { |http| http.request(request) }
    next unless response.is_a?(Net::HTTPSuccess)

    File.open("_coworkers/#{slug}#{coworker['picture_extension']}", 'wb') { |file| file.write(response.body) }
  end
else
  puts "Bad response: #{response}"
  exit(-1)
end

File.open('_data/coworker_tags.yml', 'w') do |f|
  f.write(all_tags.uniq.map { |tag| { 'name' => tag } }.to_yaml)
end
