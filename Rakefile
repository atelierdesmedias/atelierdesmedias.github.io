# frozen_string_literal: true

require 'html-proofer'

task :html_proofer do
  HTMLProofer.check_directory('./_site', {
                                disable_external: true,
                                ignore_urls: [
                                  'http://www.pizzapuce.com/',
                                  'http://redacteur-web.fr',
                                  'http://www.creature-studio.com/',
                                  'http://www.lyoncast.fr',
                                  'http://www.24hdelabandedessinee.com/',
                                  'http://www.regard-objectif.fr/'
                                ]
                              }).run
end
