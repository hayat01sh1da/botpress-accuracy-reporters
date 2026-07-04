# frozen_string_literal: true
# rbs_inline: enabled

# Identifies the Botpress bot an accuracy report is generated against.
# @rbs skip
BotpressEndpoint = Data.define(:scheme, :host, :bot_id, :user_id)

# @rbs!
#   class BotpressEndpoint < ::Data
#     attr_reader scheme: String
#     attr_reader host: String
#     attr_reader bot_id: String
#     attr_reader user_id: String
#
#     def self.new: (scheme: String, host: String, bot_id: String, user_id: String) -> instance
#                 | (String scheme, String host, String bot_id, String user_id) -> instance
#   end
