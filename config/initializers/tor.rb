Tor.configure do |config|
  config.ip = "web" # docker-compose container name
  config.port = 9050
  config.add_header('Content-Type', 'application/json')
  config.add_header('X-Peacemaker-From', configatron.my_onion)
end