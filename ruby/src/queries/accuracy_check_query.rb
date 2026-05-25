# frozen_string_literal: true
# rbs_inline: enabled

require 'net/http'
require 'csv'
require 'json'

module Queries
  class AccuracyCheckQuery
    INVALID_PATTERNS = %r![\\'|`\^"<>)(}{\]\[;/?:@&=+$,%\# ]!

    # @rbs scheme: String
    # @rbs host: String
    # @rbs bot_id: String
    # @rbs user_id: String
    # @rbs path_to_test_data: String
    # @rbs return: Array[Hash[String, untyped]]
    def self.request!(scheme:, host:, bot_id:, user_id:, path_to_test_data:)
      new(scheme:, host:, bot_id:, user_id:, path_to_test_data:).request!
    end

    # @rbs scheme: String
    # @rbs host: String
    # @rbs bot_id: String
    # @rbs user_id: String
    # @rbs path_to_test_data: String
    # @rbs return: void
    def initialize(scheme:, host:, bot_id:, user_id:, path_to_test_data:)
      @scheme    = scheme.gsub(INVALID_PATTERNS, '')
      @host      = host.gsub(INVALID_PATTERNS, '')
      @bot_id    = bot_id.gsub(INVALID_PATTERNS, '')
      @user_id   = user_id.gsub(INVALID_PATTERNS, '')
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
        net_http         = Net::HTTP.new(uri.host.to_s, uri.port)
        net_http.use_ssl = true if uri.to_s.include?('https')
        net_http.start { |http| http.request(req) }
      end
    end
  end
end
