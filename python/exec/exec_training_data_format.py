from training_data_formatter import TrainingDataFormatter
import os
import sys
import shutil
import glob
sys.path.append('./src')
sys.path.append('./src/lib')

path_to_csv_training_data = os.path.join('..', 'csv', 'training_data.csv')
path_to_json_training_data = os.path.join('..', 'json')

data_trainer = TrainingDataFormatter(path_to_csv_training_data)
data_trainer.export(path_to_json_training_data)
print(
    f'--- Successfully exported JSON training data under {path_to_json_training_data}/ ---')

pycaches = glob.glob(os.path.join('.', '**', '__pycache__'), recursive=True)
for pycache in pycaches:
    if os.path.exists(pycache):
        shutil.rmtree(pycache)
