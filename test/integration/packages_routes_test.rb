require 'test_helper'

class PackagesRoutesTest < ActionDispatch::IntegrationTest
  test 'packages landing page' do
    get '/packages'
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_select 'h1', 'Packages'
  end

  test 'view existing package' do
    get '/packages/virtual/packages'
    assert_select '.kk-package-name', 'packages'
  end

  test 'search for non existing package' do
    get '/packages/search?q=larry'
    assert_select 'h2', 'Nothing found. :( Try again?'
  end

  test 'search for existing package' do
    get '/packages/search?q=packages'
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_select '.kk-package-name', 'packages'
  end

  test 'added package page' do
    get '/packages/added'
    assert_select 'h1', 'Added Packages'
  end

  test 'updated package page' do
    get '/packages/updated'
    assert_select 'h1', 'Updated Packages'
  end

  test 'newly stable packages page' do
    get '/packages/stable'
    assert_select 'h1', 'Newly Stable Packages'
  end

  test 'keyworded packages page' do
    get '/packages/keyworded'
    assert_select 'h1', 'Keyworded Packages'
  end
end
