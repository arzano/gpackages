require 'test_helper'

class CategoriesRoutesTest < ActionDispatch::IntegrationTest

  test "can see the categories page" do
    get "/categories"
    assert_select "h1", "Packages"
  end

end
