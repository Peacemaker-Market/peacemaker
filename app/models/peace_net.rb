class PeaceNet
  def self.get(peer, path)
    # Need message to be longer than signature - lest the library complains

    # Append destination to path so that signature is unique to receiver
    # Thus preventing replay attacks. (I can't take this sig and go pretend to be you with someone else)
    if path.include?('?')
      path = "#{path}&to=#{ERB::Util.url_encode(peer.onion_address)}"
    else
      path = "#{path}?to=#{ERB::Util.url_encode(peer.onion_address)}"
    end

    signature = Base64.strict_encode64(configatron.signing_key.sign(Base64.encode64(path)))

    if Rails.env.test? && ENV['INTEGRATION_SPECS']
      uri = URI("http://#{peer.onion_address}#{path}")
      req = Net::HTTP::Get.new(uri,
        {
          'X-Peacemaker-Signature' => signature,
          'X-Peacemaker-From' => configatron.my_onion
        })
      
      Net::HTTP.start(uri.hostname, uri.port) {|http|
        http.request(req)
      }
    else
      Tor::HTTP.get(peer.onion_address, path, headers: {
        'X-Peacemaker-Signature': signature,
        'X-Peacemaker-From': configatron.my_onion
      })
    end
  end

  def self.post(peer, path, body_params = "")
    # encode body before signature to support unicode characters like ˚
    signature = configatron.signing_key.sign(Base64.encode64(body_params))
    # strict encode to avoid CR/LF in header
    signature = Base64.strict_encode64(signature)


    if Rails.env.test? && ENV['INTEGRATION_SPECS']
      uri = URI("http://#{peer.onion_address}#{path}")
      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Post.new(uri.request_uri)
      request['Content-type'] = 'application/json'
      request['X-Peacemaker-Signature'] = signature
      request['X-Peacemaker-From'] = configatron.my_onion
      
      request.body = body_params
      http.request(request)
    else
      Tor::HTTP.post(peer.onion_address, body_params, path, headers: {
        'X-Peacemaker-Signature': signature,
        'X-Peacemaker-From': configatron.my_onion
      })
    end
  end
end