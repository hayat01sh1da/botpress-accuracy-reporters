# frozen_string_literal: true
# rbs_inline: enabled

require 'net/http'
require 'csv'
require 'json'
require_relative '../botpress_endpoint'

module Queries
  # Sends each question from a test-data CSV to a Botpress /converse endpoint
  # and returns the parsed response bodies.
  class AccuracyCheckQuery
    INVALID_PATTERNS = %r![\\'|`\^"<>)(}{\]\[;/?:@&=+$,%\# ]!

    # @rbs endpoint: BotpressEndpoint
    # @rbs path_to_test_data: String
    # @rbs return: Array[Hash[String, untyped]]
    def self.request!(endpoint:, path_to_test_data:)
      new(endpoint:, path_to_test_data:).request!
    end

    # @rbs endpoint: BotpressEndpoint
    # @rbs path_to_test_data: String
    # @rbs return: void
    def initialize(endpoint:, path_to_test_data:)
      @scheme    = endpoint.scheme.gsub(INVALID_PATTERNS, '')
      @host      = endpoint.host.gsub(INVALID_PATTERNS, '')
      @bot_id    = endpoint.bot_id.gsub(INVALID_PATTERNS, '')
      @user_id   = endpoint.user_id.gsub(INVALID_PATTERNS, '')
      @test_data = CSV.read(path_to_test_data, headers: true)
    end

    # @rbs return: Array[Hash[String, untyped]]
    def request!
      authorized
      request.map(&:body).map do |res_body|
        JSON.parse(res_body)
      end
    end

    private

    attr_reader :scheme, :host, :bot_id, :user_id, :test_data, :req

    # @rbs return: URI::Generic
    def uri
      @uri ||= URI.parse("#{scheme}://#{host}/api/v1/bots/#{bot_id}/converse/#{user_id}/secured?include=suggestions")
    end

    # @rbs return: void
    def authorized
      @req                 = Net::HTTP::Post.new(uri)
      @req[:authorization] = ENV.fetch('BOTPRESS_ACCESS_TOKEN', '')
    end

    # @rbs return: Array[Net::HTTPResponse]
    def request
      test_data['Question'].map do |question|
        req.set_form_data(type: :text, text: question)
        http_client.start { |http| http.request(req) }
      end
    end

    # @rbs return: Net::HTTP
    def http_client
      @http_client ||= Net::HTTP.new(uri.host.to_s, uri.port).tap do |client|
        client.use_ssl = true if uri.to_s.include?('https')
      end
    end
  end
end
