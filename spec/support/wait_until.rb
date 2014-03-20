require 'timeout'

def wait_until(timeout = Capybara.default_wait_time)
  Timeout::timeout(timeout) {
    loop do
      break if yield
    end
  }
rescue Timeout::Error => te
  raise "Expression did not evaluate to true in #{timeout} seconds"
end

def wait_for_ajax(timeout = Capybara.default_wait_time)
  wait_until(timeout) { page.evaluate_script('jQuery.active == 0') }
end