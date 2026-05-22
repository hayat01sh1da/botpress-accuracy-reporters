import os
import sys

from invoke import Context, task

_ROOT = os.path.dirname(os.path.abspath(__file__))
for _sub in ('src', 'src/lib', 'src/queries'):
    sys.path.insert(0, os.path.join(_ROOT, _sub))

from accuracy_reporter import AccuracyReporter  # noqa: E402
from training_data_formatter import TrainingDataFormatter  # noqa: E402


@task
def export_accuracy_score_report(c: Context) -> None:
    """Export the accuracy score report to Botpress"""
    scheme = 'https'
    host = 'oasist-botpress-server.herokuapp.com'
    bot_id = 'sample-bot'
    user_id = 'oasist'
    path_to_accuracy_score_chart = os.path.join('..', 'csv')
    path_to_test_data = os.path.join(
        path_to_accuracy_score_chart, 'test_data.csv')

    accuracy_reporter = AccuracyReporter(
        scheme, host, bot_id, user_id, path_to_test_data)
    accuracy_reporter.run(path_to_accuracy_score_chart)
    print('--- Successfully exported accuracy score chart under '
          f'{path_to_accuracy_score_chart}/ ---')


@task
def format_test_data(c: Context) -> None:
    """Format the CSV test data to JSON and export"""
    path_to_csv_training_data = os.path.join(
        '..', 'csv', 'training_data.csv')
    path_to_json_training_data = os.path.join('..', 'json')

    data_trainer = TrainingDataFormatter(path_to_csv_training_data)
    data_trainer.export(path_to_json_training_data)
    print('--- Successfully exported JSON training data under '
          f'{path_to_json_training_data}/ ---')


@task(default=True)
def test(c: Context) -> None:
    """Run all tests"""
    c.run('pytest .')
