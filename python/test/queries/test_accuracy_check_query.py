# import unittest
# import os
# import sys
# sys.path.append('./src')
# sys.path.append('./src/lib')
# sys.path.append('./src/queries')
# sys.path.append('./test')
# from accuracy_check_query import AccuracyCheckQuery
# from botpress_endpoint import BotpressEndpoint
# from list_handler import __csv_to_dicts__
# from test_application import TestApplication

# class TestAccuracyCheckQuery(TestApplication):
#     def setUp(self):
#         super().setUp()
#         endpoint = BotpressEndpoint(
#             scheme='https',
#             host='oasist-botpress-server.herokuapp.com',
#             bot_id='sample-bot',
#             user_id='oasist',
#         )
#         self.path_to_test_data = os.path.join('..', 'csv', 'test_data.csv')
#         self.accuracy_check_query = AccuracyCheckQuery(endpoint, self.path_to_test_data)

#     def test_csv(self):
#         res_bodies = self.accuracy_check_query.res_bodies()
#         test_data = __csv_to_dicts__(self.path_to_test_data)
#         self.assertEqual(len(res_bodies), len(test_data))

# if __name__ == '__main__':
#     unittest.main()
