# frozen_string_literal: true
# rbs_inline: enabled

# Sends each question from a test-data CSV to a Botpress /converse endpoint
# and returns the parsed response bodies.
class AccuracyCheckQuery
  INVALID_PATTERNS = %r![\\'|`\^"<>)(}{\]\[;/?:@&=+$,%\# ]!

  # @rbs form: ScoreChartForm
  # @rbs return: Array[Hash[String, untyped]]
  def self.request!(form:)
    new(form:).request!
  end

  # @rbs form: ScoreChartForm
  # @rbs return: void
  def initialize(form:)
    @scheme       = form.scheme.gsub(INVALID_PATTERNS, '')
    @host         = form.host.gsub(INVALID_PATTERNS, '')
    @bot_id       = form.bot_id.gsub(INVALID_PATTERNS, '')
    @user_id      = form.user_id.gsub(INVALID_PATTERNS, '')
    @access_token = form.access_token.chomp
    @test_data    = CSV.read(form.test_data, headers: true)
  end

  # @rbs return: Array[Hash[String, untyped]]
  def request!
    authorized
    request.map(&:body).map do |res_body|
      JSON.parse(res_body)
    end
  end

  private

  attr_reader :scheme, :host, :bot_id, :user_id, :access_token, :test_data, :req

  # @rbs return: URI::Generic
  def uri
    @uri ||= URI.parse("#{scheme}://#{host}/api/v1/bots/#{bot_id}/converse/#{user_id}/secured?include=suggestions")
  end

  # @rbs return: void
  def authorized
    @req                 = Net::HTTP::Post.new(uri)
    @req[:authorization] = access_token
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
