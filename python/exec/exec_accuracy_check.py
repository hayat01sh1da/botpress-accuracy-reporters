from accuracy_reporter import AccuracyReporter
import os
import sys
import shutil
import glob
sys.path.append('./src')
sys.path.append('./src/lib')
sys.path.append('./src/queries')

scheme = 'https'
host = 'oasist-botpress-server.herokuapp.com'
bot_id = 'sample-bot'
user_id = 'oasist'
path_to_accuracy_score_chart = os.path.join('..', 'csv')
path_to_test_data = os.path.join(path_to_accuracy_score_chart, 'test_data.csv')

accuracy_reporter = AccuracyReporter(
    scheme, host, bot_id, user_id, path_to_test_data)
accuracy_reporter.run(path_to_accuracy_score_chart)
print(
    f'--- Successfully exported accuracy score chart under {path_to_accuracy_score_chart}/ ---')

pycaches = glob.glob(os.path.join('.', '**', '__pycache__'), recursive=True)
for pycache in pycaches:
    if os.path.exists(pycache):
        shutil.rmtree(pycache)
