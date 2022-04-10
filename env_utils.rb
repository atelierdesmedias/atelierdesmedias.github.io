# frozen_string_literal: true

def get_env_or_exit(name)
  result = ENV[name]
  if result.nil?
    puts "Please set environment variable: #{name}"
    exit(-1)
  end
  result
end
