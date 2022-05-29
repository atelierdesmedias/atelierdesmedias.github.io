# frozen_string_literal: true

require 'koala'
require 'mini_magick'
require 'stringex'
require 'time'

require './env_utils'

access_token = get_env_or_exit('FACEBOOK_TOKEN')
page_id = get_env_or_exit('FACEBOOK_PAGE_ID')

graph = Koala::Facebook::API.new(access_token)
events = graph.get_connections(page_id, 'events', fields: %w[id name start_time place description cover])
events.each do |event|
  next unless event['name'] && event['cover']

  puts '---'
  pp event
  date = Time.parse(event['start_time'])
  slug = "#{date.strftime('%F')}-#{event['name'].to_url}"
  File.open("_events/#{slug}.md", 'w') do |f|
    f.write("---\n")
    f.write("name: \"#{event['name']}\"\n")
    f.write("event_time: \"#{date}\"\n")
    f.write("place: \"#{event['place']['name']}\"\n") if event['place']
    f.write("event_id: #{event['id']}\n")
    f.write("cover: #{slug}.jpg\n")
    f.write("---\n\n")
    description = event['description']
    f.write("\n#{description}\n") unless description.nil? || description.empty?
  end

  # Fetch event cover
  image = MiniMagick::Image.open(event['cover']['source'])
  image.resize("x300\>")
  image.write("_events/#{slug}.jpg")
end
