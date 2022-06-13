# frozen_string_literal: true

# _plugins/shuffle.rb
module Jekyll
  # Basic filter shuffling an array
  module ShuffleFilter
    def shuffle(array)
      array.shuffle
    end
  end
end

Liquid::Template.register_filter(Jekyll::ShuffleFilter)
