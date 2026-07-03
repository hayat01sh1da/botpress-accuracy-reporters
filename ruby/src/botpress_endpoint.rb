# frozen_string_literal: true
# rbs_inline: enabled

# Identifies the Botpress bot an accuracy report is generated against.
BotpressEndpoint = Data.define(:scheme, :host, :bot_id, :user_id)
