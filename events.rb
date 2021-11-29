# frozen_string_literal: true

require 'date'
require 'json'
require 'net/http'
require "open-uri"
require 'stringex'
require 'uri'

url = ENV['FACEBOOK_GRAPH_URL']
if url.nil?
  puts 'Please set FACEBOOK_GRAPH_URL'
  exit(-1)
end
page_id = ENV['FACEBOOK_PAGE_ID']
if page_id.nil?
  puts 'Please set FACEBOOK_PAGE_ID'
  exit(-1)
end
token = ENV['FACEBOOK_TOKEN']
if token.nil?
  puts 'Please set FACEBOOK_TOKEN'
  exit(-1)
end

uri = URI(url + page_id)
uri.query = URI.encode_www_form({
                                  fields: "events",
                                  access_token: token
                                })
res = Net::HTTP.get_response(uri)
if res.is_a?(Net::HTTPSuccess)
  Dir['_events/*.*'].each do |f|
    puts "Deleting #{f}..."
    File.delete(f)
  end
  events = JSON.parse(res.body)['events']['data']
  events.each do |event|
    name = event['name']
    description = event['description']
    date = Date.parse(event['start_time'])
    slug = name.to_url
    puts name, slug, date
    File.open("_events/#{slug}.md", 'w') do |f|
      f.write("---\n")
      f.write("name: #{name}\n")
      f.write("layout: default\n")
      f.write("date: #{date}\n")
      f.write("---\n\n")
      f.write("\n#{description}\n") unless description.nil? || description.empty?
    end

    # Fetch event cover
    uri = URI(url + event['id'])
    uri.query = URI.encode_www_form({
                                  fields: "cover",
                                  access_token: token
                                })
    res = Net::HTTP.get_response(uri)
    if res.is_a?(Net::HTTPSuccess)
      cover_source = JSON.parse(res.body)['cover']['source']
      URI.open(cover_source) do |image|
        File.open("_events/#{slug}.jpg", "wb") do |file|
          file.write(image.read)
        end
      end
    end
  end
else
  puts "Bad response: #{res}"
  exit(-1)
end
