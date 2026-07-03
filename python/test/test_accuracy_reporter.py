# import unittest
# import os
# import glob
# import sys
# sys.path.append('./src')
# from accuracy_reporter import AccuracyReporter
# from botpress_endpoint import BotpressEndpoint
# from test_application import TestApplication

# class TestAccuracyReporter(TestApplication):
#     def setUp(self):
#         super().setUp()
#         endpoint = BotpressEndpoint(
#             scheme='https',
#             host='oasist-botpress-server.herokuapp.com',
#             bot_id='sample-bot',
#             user_id='oasist',
#         )
#         path_to_test_data = os.path.join('..', 'csv', 'test_data.csv')
#         self.accuracy_reporter = AccuracyReporter(endpoint, path_to_test_data, self.dirname)

#     def test_export_chart(self):
#         self.accuracy_reporter.report(self.dirname)
#         self.assertTrue(any(glob.glob('{dirname}/accuracy_score_chart*.csv'.format(dirname = self.dirname))))

# if __name__ == '__main__':
#     unittest.main()
