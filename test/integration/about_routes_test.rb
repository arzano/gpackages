require 'test_helper'

class AboutRoutesTest < ActionDispatch::IntegrationTest
  test 'can see the about page' do
    get '/about'
    assert_select 'h1', 'About packages.gentoo.org'
  end

  test 'can see the feedback page' do
    get '/about/feedback'
    assert_select 'h1', 'Feedback'
  end

  test 'can see the about feeds page' do
    get '/about/feeds'
    assert_select 'h1', 'Update Feeds'
  end

  test 'can see the about help page' do
    get '/about/help'
    assert_select 'h1', 'Help'
  end

  test 'can see the changelog page' do
    get '/about/changelog'
    assert_select 'h1', 'Changelog'
  end
end
