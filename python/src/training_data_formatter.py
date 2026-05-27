import datetime
import os
import sys

sys.path.append('./src/lib')

from format import Format  # noqa: E402


class TrainingDataFormatter(Format):
    """Reads a CSV training-data file, converts it through Format, and writes
    the result as a timestamped JSON file under the requested directory."""

    @classmethod
    def run(cls, path_to_csv_training_data: str,
            path_to_json_training_data: str) -> None:
        cls(path_to_csv_training_data, path_to_json_training_data)._run()

    def __init__(self, path_to_csv_training_data: str,
                 path_to_json_training_data: str) -> None:
        self._path_to_csv_training_data = path_to_csv_training_data
        self._path_to_json_training_data = path_to_json_training_data

    # private

    def _run(self) -> None:
        with open(self._filename(), 'w') as f:
            f.write(self.to_json(self._path_to_csv_training_data))

    def _filename(self) -> str:
        return os.path.join(
            self._path_to_json_training_data,
            f'training_data_{datetime.datetime.now():%Y%m%d%H%M%S}.json',
        )
