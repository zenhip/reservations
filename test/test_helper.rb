ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'

class ActiveSupport::TestCase
  include AuthenticatedTestHelper

  # Extra init stuffs pirms ik katra testa
  # def setup
  # end
  
  # restful_authentication access_denied redirektē uz login lapu
  def assert_access_denied
    assert_redirected_to login_path
  end
end

class Test::Unit::TestCase
  self.use_transactional_fixtures = true
  self.use_instantiated_fixtures  = false
  fixtures :all
end
