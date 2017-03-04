module Base64Urlsafe
  def self.uuid2url(uuid)
    str_arr = uuid.scan(/[0-9a-f]{4}/)
    num_arr = str_arr.map{ |e| e.to_i(16) }
    packed = num_arr.pack('n*')
    Base64.urlsafe_encode64(packed).delete('=')
  end

  def self.url2uuid(url)
    bits = Base64.urlsafe_decode64(url + '=' * (-1 * url.size & 3))
    ary = bits.unpack("NnnnnN")
    "%08x-%04x-%04x-%04x-%04x%08x" % ary
  end
end
