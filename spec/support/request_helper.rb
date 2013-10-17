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

def visit_hunting_page(force = false)
  visit hunting_path if force
  visit hunting_path unless current_path == hunting_path
end

def click_own_bucket
  visit_hunting_page
  click_on 'add_cookie_link'
end

def click_steal_bucket
  visit_hunting_page
  click_on 'get_steal_bucket_link'
end

def click_to_steal(target)
  target_link = "steal_from_hunter_#{target.id}"
  visit_hunting_page(true) unless page.has_link?(target_link)
  click_on target_link
end

def steal_bucket
  StealBucket.instance
end