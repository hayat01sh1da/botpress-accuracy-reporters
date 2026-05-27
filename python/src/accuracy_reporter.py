import datetime
import os
import sys

sys.path.append('./src/lib')
sys.path.append('./src/queries')

from accuracy_check_query import AccuracyCheckQuery  # noqa: E402
from csv_chart_drawer import CsvChartDrawer  # noqa: E402


class AccuracyReporter:
    """Exports an accuracy score chart by querying a Botpress endpoint with
    the rows of a test-data CSV and writing the per-question scores out as
    CSV."""

    @classmethod
    def run(
        cls,
        scheme: str,
        host: str,
        bot_id: str,
        user_id: str,
        path_to_test_data: str,
        path_to_accuracy_score_chart: str,
    ) -> None:
        cls(
            scheme,
            host,
            bot_id,
            user_id,
            path_to_test_data,
            path_to_accuracy_score_chart,
        )._run()

    def __init__(
        self,
        scheme: str,
        host: str,
        bot_id: str,
        user_id: str,
        path_to_test_data: str,
        path_to_accuracy_score_chart: str,
    ) -> None:
        self._scheme = scheme
        self._host = host
        self._bot_id = bot_id
        self._user_id = user_id
        self._path_to_test_data = path_to_test_data
        self._path_to_accuracy_score_chart = path_to_accuracy_score_chart
        self._res_bodies = AccuracyCheckQuery.request(
            scheme=scheme,
            host=host,
            bot_id=bot_id,
            user_id=user_id,
            path_to_test_data=path_to_test_data,
        )

    # private

    def _run(self) -> None:
        csv_chart = CsvChartDrawer.run(
            path_to_test_data=self._path_to_test_data,
            res_bodies=self._res_bodies,
        )
        with open(self._filename(), 'w') as f:
            f.write(csv_chart)

    def _filename(self) -> str:
        return os.path.join(
            self._path_to_accuracy_score_chart,
            f'accuracy_score_chart_{datetime.datetime.now():%Y%m%d%H%M%S}.csv',
        )
