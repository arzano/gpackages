require 'test_helper'

class FeedsTest < ActionDispatch::IntegrationTest
  test 'can see the added packages feed' do
    get '/packages/added.atom'
    assert_response :success
    assert_equal 'application/atom+xml; charset=utf-8', @response.content_type
  end

  test 'can see the updates packages feed' do
    get '/packages/updated.atom'
    assert_response :success
    assert_equal 'application/atom+xml; charset=utf-8', @response.content_type
  end

  test 'can see the newly stable packages feed' do
    get '/packages/stable.atom'
    assert_response :success
    assert_equal 'application/atom+xml; charset=utf-8', @response.content_type
  end

  test 'can see the keyworded packages feed' do
    get '/packages/keyworded.atom'
    assert_response :success
    assert_equal 'application/atom+xml; charset=utf-8', @response.content_type
  end
end
