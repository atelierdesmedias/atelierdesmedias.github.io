# frozen_string_literal: true

require 'koala'
require 'mini_magick'
require 'stringex'
require 'time'
require 'yaml'

require './env_utils'

access_token = get_env_or_exit('FACEBOOK_TOKEN')
page_id = get_env_or_exit('FACEBOOK_PAGE_ID')

graph = Koala::Facebook::API.new(access_token)
fb_events = graph.get_connections(page_id, 'events', fields: %w[id name start_time place description cover])
fb_events.each do |fb_event|
  next unless fb_event['name'] && fb_event['cover']

  puts '---'
  pp fb_event
  event_time = Time.parse(fb_event['start_time'])
  slug = "#{event_time.strftime('%F')}-#{fb_event['name'].to_url}"
  event = { 'name' => fb_event['name'],
            'date' => event_time,
            'event_id' => fb_event['id'],
            'cover' => "#{slug}.jpg" }
  event['place'] = (fb_event['place']['name']).to_s if fb_event['place']
  File.open("_events/#{slug}.md", 'w') do |f|
    f.write("#{event.to_yaml}---\n")
    description = fb_event['description'].gsub(/\r/, '')
    f.write("\n#{description}\n") unless description.nil? || description.empty?
  end

  # Fetch event cover
  image = MiniMagick::Image.open(fb_event['cover']['source'])
  image.resize("x300\>")
  image.write("_events/#{slug}.jpg")
end
