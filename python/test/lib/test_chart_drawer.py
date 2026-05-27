import csv
import json
import os

from csv_chart_drawer import CsvChartDrawer


def test_csv() -> None:
    path_to_test_data = os.path.join('..', 'csv', 'test_data.csv')
    path_to_res_bodies = os.path.join('..', 'json', 'res_bodies.json')
    with open(path_to_res_bodies) as f:
        res_bodies = json.load(f)
    csv_chart = CsvChartDrawer.run(path_to_test_data, res_bodies)
    with open(path_to_test_data) as f:
        test_data = list(csv.reader(f))

    assert len(test_data) == len(csv_chart.splitlines())
