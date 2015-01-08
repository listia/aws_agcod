# Currently AGCOD v2 uses v4 Signature for it's authentication,
# this class generates signed headers for making proper request to AGCOD service.
#
# Based on https://github.com/ifeelgoods/aws4/blob/master/lib/aws4/signer.rb
require "openssl"
require "uri"
require "pathname"

module AwsAgcod
  class Signature
    SERVICE = "AGCODService"

    def initialize(credentials)
      @access_key = credentials.access_key
      @secret_key = credentials.secret_key
      @region = credentials.region || DEFAULT_REGION
    end

    def sign(uri, headers, body = "")
      @uri = uri
      @headers = headers
      @body = body
      @date = headers["x-amz-date"]

      signed_headers = headers.dup
      signed_headers["Authorization"] = authorization

      signed_headers
    end

    private

    def authorization
      [
        "AWS4-HMAC-SHA256 Credential=#{@access_key}/#{credential_string}",
        "SignedHeaders=#{@headers.keys.map(&:downcase).sort.join(";")}",
        "Signature=#{signature}"
      ].join(", ")
    end

    # Reference http://docs.aws.amazon.com/general/latest/gr/sigv4-calculate-signature.html
    def signature
      k_date = hmac("AWS4" + @secret_key, @date[0, 8])
      k_region = hmac(k_date, @region)
      k_service = hmac(k_region, SERVICE)
      k_credentials = hmac(k_service, "aws4_request")
      hexhmac(k_credentials, string_to_sign)
    end

    # Reference http://docs.aws.amazon.com/general/latest/gr/sigv4-create-string-to-sign.html
    def string_to_sign
      @string_to_sign ||= [
        "AWS4-HMAC-SHA256", # Algorithm
        @date, # RequestDate
        credential_string, # CredentialScope
        hexdigest(canonical_request) # HashedCanonicalRequest
      ].join("\n")
    end

    def credential_string
      @credential_string ||= [@date[0, 8], @region, SERVICE, "aws4_request"].join("/")
    end

    # Reference http://docs.aws.amazon.com/general/latest/gr/sigv4-create-canonical-request.html
    def canonical_request
      @canonical_request ||= [
        "POST", # HTTPRequestMethod
        Pathname.new(@uri.path).cleanpath.to_s, # CanonicalURI
        @uri.query, # CanonicalQueryString
        @headers.sort.map { |k, v| [k.downcase, v.strip].join(":") }.join("\n") + "\n", # CanonicalHeaders
        @headers.sort.map { |k, v| k.downcase }.join(";"), # SignedHeaders
        hexdigest(@body) # HexEncode(Hash(RequestPayload))
      ].join("\n")
    end

    # Hexdigest simply produces an ascii safe way
    # to view the bytes produced from the hash algorithm.
    # It takes the hex representation of each byte
    # and concatenates them together to produce a string
    def hexdigest(value)
      Digest::SHA256.new.update(value).hexdigest
    end

    # Hash-based message authentication code (HMAC)
    # is a mechanism for calculating a message authentication code
    # involving a hash function in combination with a secret key
    def hmac(key, value)
      OpenSSL::HMAC.digest(OpenSSL::Digest::Digest.new("sha256"), key, value)
    end

    def hexhmac(key, value)
      OpenSSL::HMAC.hexdigest(OpenSSL::Digest::Digest.new("sha256"), key, value)
    end
  end
end
