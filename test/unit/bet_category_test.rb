require 'test_helper'

class BetCategoryTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert BetCategory.new.valid?
  end
end
