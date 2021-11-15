require 'faraday'
require 'faraday_middleware'
require 'rspec'
require_relative '../spec/tests/dados/dados'
require 'faker'

Faraday.new do |f|
    f.request :json # encode req bodies as JSON
    f.request :retry, max: 1 # retry transient failures
    f.response :follow_redirects # follow redirects
    f.response :json # decode response bodies as JSON
    f.adapter(:net_http)
  end


RSpec.configure do |config|
  include User
  config.color = true
  config.formatter = :documentation
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
  config.shared_context_metadata_behavior = :apply_to_host_groups

end
