require 'test_helper'

class MainRoutesTest < ActionDispatch::IntegrationTest
  test 'view landing page' do
    get '/'
    assert_select 'h2', 'Welcome to the Home of 1 Gentoo Packages'
  end

  test 'test route not present' do
    assert_raises(ActionController::RoutingError) do
      get '/larry'
    end
  end
end
