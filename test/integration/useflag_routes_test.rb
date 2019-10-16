require 'test_helper'

class UseflagRoutesTest < ActionDispatch::IntegrationTest

  test "can see the useflags page" do
    get "/useflags"
    assert_select "h1", "USE flags"
  end

  test "search for multiple existing useflag" do
    get "/useflags/search?q=systemd"
    assert_select "h1", "USE Flag Search Results for systemd"
  end

  test "search for non existing useflag" do
    get "/useflags/search?q=larry"
    assert_select "h1", "USE Flag Search Results for larry"
  end

  test "view existing useflag" do
    get "/useflags/systemd"
    assert_select "h1", "systemd"
  end

end
