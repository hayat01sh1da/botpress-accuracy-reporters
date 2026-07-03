import datetime
import os
import sys

sys.path.append('./src/lib')
sys.path.append('./src/queries')

from accuracy_check_query import AccuracyCheckQuery  # noqa: E402
from botpress_endpoint import BotpressEndpoint  # noqa: E402
from csv_chart_drawer import CsvChartDrawer  # noqa: E402


class AccuracyReporter:
    """Exports an accuracy score chart by querying a Botpress endpoint with
    the rows of a test-data CSV and writing the per-question scores out as
    CSV."""

    @classmethod
    def run(
        cls,
        endpoint: BotpressEndpoint,
        path_to_test_data: str,
        path_to_accuracy_score_chart: str,
    ) -> None:
        cls(
            endpoint,
            path_to_test_data,
            path_to_accuracy_score_chart,
        )._run()

    def __init__(
        self,
        endpoint: BotpressEndpoint,
        path_to_test_data: str,
        path_to_accuracy_score_chart: str,
    ) -> None:
        self._endpoint = endpoint
        self._path_to_test_data = path_to_test_data
        self._path_to_accuracy_score_chart = path_to_accuracy_score_chart
        self._res_bodies = AccuracyCheckQuery.request(
            endpoint=endpoint,
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
