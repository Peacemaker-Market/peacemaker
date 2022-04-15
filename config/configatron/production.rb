# Override your default settings for the Production environment here.
#
# Example:
#   configatron.file.storage = :s3
configatron.my_onion = ENV['P2P_SERVICE_ONION'] || File.read('hidden_service/hostname').to_s.strip rescue nil
