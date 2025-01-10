# frozen_string_literal: true

module Jekyll
  # This class filters posts in development environment
  class FilterPosts < Generator
    safe true
    priority :highest

    def generate(site)
      return unless Jekyll.env == 'development'

      limit_posts = site.config['development']['limit_posts'] || 5
      site.posts.docs = site.posts.docs.last(limit_posts)
    end
  end
end
