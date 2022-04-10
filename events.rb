# frozen_string_literal: true

require 'koala'
require 'open-uri'
require 'stringex'
require 'time'

require './env_utils'

access_token = get_env_or_exit('FACEBOOK_TOKEN')
page_id = get_env_or_exit('FACEBOOK_PAGE_ID')

graph = Koala::Facebook::API.new(access_token)
events = graph.get_connections(page_id, 'events', fields: %w[id name start_time place description cover])
events.each do |event|
  puts '---'
  pp event
  slug = event['name'].to_url
  File.open("_events/#{slug}.md", 'w') do |f|
    f.write("---\n")
    f.write("name: \"#{event['name']}\"\n")
    f.write("event_time: \"#{Time.parse(event['start_time'])}\"\n")
    f.write("place: \"#{event['place']['name']}\"\n")
    f.write("event_id: #{event['id']}\n")
    f.write("---\n\n")
    description = event['description']
    f.write("\n#{description}\n") unless description.nil? || description.empty?
  end

  # Fetch event cover
  URI.parse(event['cover']['source']).open do |image|
    File.open("_events/#{slug}.jpg", 'wb') do |file|
      file.write(image.read)
    end
  end
end
