# Simulates an ajax request "starting"
def start_ajax
  page.evaluate_script "$(document).trigger('ajaxStart');"
end

# Simulates an ajax request "stopping"
def stop_ajax
  page.evaluate_script "$(document).trigger('ajaxStop');"
end