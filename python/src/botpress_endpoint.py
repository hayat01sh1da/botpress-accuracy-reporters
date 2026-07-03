from dataclasses import dataclass


@dataclass(frozen=True)
class BotpressEndpoint:
    """Identifies the Botpress bot an accuracy report is generated
    against."""

    scheme: str
    host: str
    bot_id: str
    user_id: str
