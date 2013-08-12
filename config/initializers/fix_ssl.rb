require 'open-uri'
require 'net/https'

module Net
  class HTTP
    alias_method :original_use_ssl=, :use_ssl=

    def use_ssl=(flag)
      if Rails.env.production?
        self.ca_file = '/usr/lib/ssl/certs/ca-certificates.crt'
      else
        self.ca_file = Rails.root.join('lib/ca-bundle.crt').to_s
      end
      self.verify_mode = OpenSSL::SSL::VERIFY_PEER
      self.original_use_ssl = flag
    end
  end
end
