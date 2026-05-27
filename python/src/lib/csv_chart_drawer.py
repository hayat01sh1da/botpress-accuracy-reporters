import csv
import io
from typing import Any


class CsvChartDrawer:
    """Builds a CSV chart that pairs each test question with the confidence
    scores returned by Botpress for every candidate answer."""

    @classmethod
    def run(cls, path_to_test_data: str,
            res_bodies: list[dict[str, Any]]) -> str:
        return cls(path_to_test_data, res_bodies)._run()

    def __init__(self, path_to_test_data: str,
                 res_bodies: list[dict[str, Any]]) -> None:
        with open(path_to_test_data) as f:
            self._test_data = list(csv.DictReader(f))
        self._res_bodies = res_bodies

    # private

    def _run(self) -> str:
        buf = io.StringIO()
        writer = csv.writer(buf, lineterminator='\n')
        writer.writerow(self._headers())
        for index, row in enumerate(self._rows()):
            writer.writerow(
                [self._test_data[index]['ID'],
                 self._test_data[index]['Question']] + row
            )
        return buf.getvalue()

    def _headers(self) -> list[str]:
        return ['ID', 'Test_Data'] + [datum['ID'] for datum in self._test_data]

    def _score_tables(self) -> list[dict[str, float]]:
        return [
            {
                suggestion['payloads'][0]['text']: suggestion['confidence']
                for suggestion in res_body['suggestions']
            }
            for res_body in self._res_bodies
        ]

    def _rows(self) -> list[list[str]]:
        return [self._score_row_for(score_table)
                for score_table in self._score_tables()]

    def _score_row_for(self, score_table: dict[str, float]) -> list[str]:
        answers = [datum['Answer'] for datum in self._test_data]
        scores = ['0.0%'] * len(answers)
        for answer, score in score_table.items():
            index = answers.index(answer)
            scores[index] = f'{score * 100:.1f}%'
        return scores
