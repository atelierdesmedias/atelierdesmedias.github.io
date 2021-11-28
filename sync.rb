# frozen_string_literal: true

require 'uri'
require 'net/http'
require 'json'
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

uri = URI(url)
uri.query = URI.encode_www_form({
                                  xpage: 'plain',
                                  outputSyntax: 'plain',
                                  code: code
                                })
res = Net::HTTP.get_response(uri)
if res.is_a?(Net::HTTPSuccess)
  Dir['_coworkers/*.md'].each do |f|
    puts "Deleting #{f}..."
    File.delete(f)
  end
  coworkers = JSON.parse(res.body)['coworkers']
  coworkers.each do |coworker|
    name = "#{coworker['first_name']} #{coworker['last_name']}"
    slug = name.to_url
    formula = coworker['formule']
    next unless coworker['public_enable'] && %w[nomade fixe].include?(formula)

    puts name, slug, formula
    File.open("_coworkers/#{slug}.md", 'w') do |f|
      f.write("---\n")
      f.write("name: #{name}\n")
      f.write("slug: #{slug}\n")
      f.write("layout: default\n")
      f.write("---\n\n")
      f.write("# #{name}\n")
      quiesttu = coworker['public_quiesttu']
      f.write("\n## Qui es-tu ?\n\n#{quiesttu}\n") unless quiesttu.nil? || quiesttu.empty?
      quefaistu = coworker['public_quefaistu']
      f.write("\n## Que fais-tu ?\n\n#{quefaistu}\n") unless quefaistu.nil? || quefaistu.empty?
      pourquoicoworking = coworker['public_pourquoicoworking']
      unless pourquoicoworking.nil? || pourquoicoworking.empty?
        f.write("\n## Pourquoi le coworking ?\n\n#{pourquoicoworking}\n")
      end
    end
  end
else
  puts "Bad response: #{res}"
  exit(-1)
end
