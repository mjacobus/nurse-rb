require 'test_helper'

class NurseTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Nurse::VERSION
  end
end
