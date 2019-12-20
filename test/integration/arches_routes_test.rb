require 'test_helper'

class ArchesRoutesTest < ActionDispatch::IntegrationTest
  test 'can see the arches page' do
    get '/arches'
    assert_select 'h1', 'Architectures'
  end

  test 'view keyworded packages for arch' do
    arches = %w[alpha amd64 arm arm64 hppa ia64 ppc ppc64 sparc x86]
    arches.each do |arch|
      get ('/arches/' + arch + '/keyworded')
      assert_select 'h1', ('Keyworded Packages (' + arch + ')')
    end
  end

  test 'view stable packages for arch' do
    arches = %w[alpha amd64 arm arm64 hppa ia64 ppc ppc64 sparc x86]
    arches.each do |arch|
      get ('/arches/' + arch + '/stable')
      assert_select 'h1', ('Newly Stable Packages (' + arch + ')')
    end
  end
end
