# frozen_string_literal: true
# rbs_inline: enabled

# Identifies the Botpress bot an accuracy report is generated against.
BotpressEndpoint = Data.define(
  :scheme,  #: String
  :host,    #: String
  :bot_id,  #: String
  :user_id  #: String
)
