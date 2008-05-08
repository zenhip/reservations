require File.dirname(__FILE__) + '/../test_helper'

class CategoryTest < ActiveSupport::TestCase

  def test_should_have_many_products
    assert categories(:bricks).products.any?
  end

  def test_should_not_destroy_products
    assert_no_difference "Product.count" do
      categories(:bricks).destroy
    end
  end

end
