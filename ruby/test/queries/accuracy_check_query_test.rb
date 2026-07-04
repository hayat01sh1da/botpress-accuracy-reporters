# frozen_string_literal: true
# rbs_inline: enabled

# require 'csv'
# require 'json'
# require_relative '../application_test'
# require_relative '../../src/queries/accuracy_check_query'

# class AccuracyCheckQueryTest < ApplicationTest
#   def setup
#     @endpoint = BotpressEndpoint.new(
#       scheme: 'https',
#       host: 'oasist-botpress-server.herokuapp.com',
#       bot_id: 'sample-bot',
#       user_id: 'oasist'
#     )
#     @path_to_test_data = File.join('..', 'csv', 'test_data.csv')
#   end

#   def test_res_bodies
#     res_bodies = ::Queries::AccuracyCheckQuery.request!(endpoint:, path_to_test_data:)
#     test_data  = CSV.read(path_to_test_data, headers: true)
#     assert_equal test_data.length, res_bodies.length
#   end

#   private

#   attr_reader :endpoint, :path_to_test_data
# end
