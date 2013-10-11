include Warden::Test::Helpers

module LoginHunter
  def login_hunter(hunter = create(:hunter), attrs = {})
    login_as hunter
    hunter
  end
end

RSpec.configure do |config|
  config.include LoginHunter
end