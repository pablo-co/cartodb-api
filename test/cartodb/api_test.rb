require 'test_helper'

class CartoDB::ApiTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::CartoDB::Api::VERSION
  end
end
