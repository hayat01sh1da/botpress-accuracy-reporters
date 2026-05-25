# frozen_string_literal: true
# rbs_inline: enabled

require 'minitest/autorun'

class ApplicationTest < Minitest::Test
  def setup
    @path_to_tmp_test_dir = File.join('test', 'tmp')
    FileUtils.mkdir_p(path_to_tmp_test_dir)
  end

  def teardown
    files_to_remove = Dir[File.join(path_to_tmp_test_dir, '*')]
    FileUtils.rm_rf(files_to_remove) if files_to_remove.any?
    Dir.delete(path_to_tmp_test_dir)
  end

  private

  attr_reader :path_to_tmp_test_dir
end
