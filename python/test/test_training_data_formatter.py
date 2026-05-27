import glob
import os

from training_data_formatter import TrainingDataFormatter


def test_export(tmp_dir: str) -> None:
    path_to_csv_training_data = os.path.join(
        '..', 'csv', 'training_data.csv')
    TrainingDataFormatter.run(
        path_to_csv_training_data=path_to_csv_training_data,
        path_to_json_training_data=tmp_dir,
    )
    assert any(glob.glob(os.path.join(tmp_dir, 'training_data*.json')))
