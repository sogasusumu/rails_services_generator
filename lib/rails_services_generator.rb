require "rails_services_generator/railtie"

module RailsServicesGenerator
  # Your code goes here...
  class << self
    def call
      puts 'called'
    end
  end
end
