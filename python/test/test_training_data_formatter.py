import glob
import os

from training_data_formatter import TrainingDataFormatter


def test_export(tmp_dir: str) -> None:
    TrainingDataFormatter(
        os.path.join(
            '..',
            'csv',
            'training_data.csv')).export(tmp_dir)
    assert any(glob.glob(f'{tmp_dir}/training_data*.json'))
