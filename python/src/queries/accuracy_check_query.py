import csv
import json
import os
import re
import urllib.request
from typing import Any
from urllib.parse import urlencode

from botpress_endpoint import BotpressEndpoint

INVALID_PATTERNS = r'[\\\'|`^"<>)(}{\]\[;/?:@&=+$,%# ]'


class AccuracyCheckQuery:
    """Sends each question from a test-data CSV to a Botpress /converse
    endpoint and returns the parsed response bodies."""

    @classmethod
    def request(
        cls,
        endpoint: BotpressEndpoint,
        path_to_test_data: str,
    ) -> list[dict[str, Any]]:
        return cls(endpoint, path_to_test_data)._request()

    def __init__(
        self,
        endpoint: BotpressEndpoint,
        path_to_test_data: str,
    ) -> None:
        self._scheme = re.sub(INVALID_PATTERNS, '', endpoint.scheme)
        self._host = re.sub(INVALID_PATTERNS, '', endpoint.host)
        self._bot_id = re.sub(INVALID_PATTERNS, '', endpoint.bot_id)
        self._user_id = re.sub(INVALID_PATTERNS, '', endpoint.user_id)
        with open(path_to_test_data) as f:
            self._test_data = list(csv.DictReader(f))

    # private

    def _request(self) -> list[dict[str, Any]]:
        return [json.loads(response.read()) for response in self._responses()]

    def _uri(self) -> str:
        return (
            f'{self._scheme}://{self._host}/api/v1/bots/{self._bot_id}'
            f'/converse/{self._user_id}/secured?include=suggestions'
        )

    def _responses(self) -> list[Any]:
        uri = self._uri()
        headers = {
            'Content-Type': 'application/x-www-form-urlencoded',
            'Authorization': os.environ.get('BOTPRESS_ACCESS_TOKEN', ''),
        }
        return [
            urllib.request.urlopen(
                urllib.request.Request(
                    uri,
                    urlencode(
                        {'type': 'text', 'text': test_datum['Question']}
                    ).encode(),
                    headers,
                )
            )
            for test_datum in self._test_data
        ]
