require 'test_helper'

class AccTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Acc::VERSION
  end
end
