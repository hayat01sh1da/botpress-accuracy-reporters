import csv
import json
from typing import Any


class Format:
    """Converts a CSV of question/answer pairs into the JSON shape Botpress
    expects for Q&A training data. Designed to be mixed into a class that
    owns the CSV path."""

    def template(self, array: list[Any] | None = None) -> dict[str, Any]:
        items = list(array) if array is not None else []
        return {
            'id': '',
            'data': {
                'action': 'text',
                'contexts': ['sample'],
                'enabled': True,
                'answers': {'ja': items},
                'questions': {'ja': list(items)},
                'redirectFlow': '',
                'redirectNode': '',
            },
        }

    def to_json(self, path_to_csv_training_data: str,
                array: list[Any] | None = None) -> str:
        result: list[dict[str, Any]] = list(array) if array is not None else []
        fmt = self.template(array=list(array) if array is not None else [])
        with open(path_to_csv_training_data) as f:
            for training_datum in csv.DictReader(f):
                fmt = self._merge_training_datum(fmt, training_datum)
                fmt['data']['questions']['ja'] = self._uniq(
                    fmt['data']['questions']['ja'])
                result.append(fmt)
        return json.dumps({'qnas': self._uniq(result)},
                          ensure_ascii=False, indent=2)

    # private

    def _merge_training_datum(
            self, fmt: dict[str, Any],
            training_datum: dict[str, str]) -> dict[str, Any]:
        answers = fmt['data']['answers']['ja']
        if answers and answers[-1] == training_datum['Answer']:
            fmt['data']['questions']['ja'].append(training_datum['Question'])
            return fmt
        return self._start_new_format(training_datum)

    def _start_new_format(
            self, training_datum: dict[str, str]) -> dict[str, Any]:
        new_format = self.template()
        new_format['id'] = training_datum['ID']
        new_format['data']['questions']['ja'].append(training_datum['Question'])
        new_format['data']['answers']['ja'].append(training_datum['Answer'])
        return new_format

    @staticmethod
    def _uniq(items: list[Any]) -> list[Any]:
        result: list[Any] = []
        for item in items:
            if item not in result:
                result.append(item)
        return result
