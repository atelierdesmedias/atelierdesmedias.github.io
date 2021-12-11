# frozen_string_literal: true

require 'html-proofer'

task :html_proofer do
  sh 'bundle exec jekyll build'
  options = {
    assume_extension: true,
    disable_external: true
  }
  HTMLProofer.check_directory('./_site', options).run
end
