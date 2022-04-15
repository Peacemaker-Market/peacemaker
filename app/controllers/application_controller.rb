class ApplicationController < ActionController::Base
  http_basic_authenticate_with name: ENV.fetch('WEB_USERNAME', 'admin'), password: ENV.fetch('WEB_PASSWORD', 'secret')

  # TODO: verify host is only ENV['APP_ONION']
end
