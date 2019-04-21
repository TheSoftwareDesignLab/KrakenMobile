require 'calabash-android/helpers'
require 'calabash-android/java_keystore'

module KrakenMobile
  module CalabashAndroid
    module ApkSigner
      def self.is_apk_signed? apk_path
        keystores = JavaKeystore.get_keystores
        apk_fingerprint = fingerprint_from_apk(apk_path)
        keystores.select { |k| k.fingerprint == apk_fingerprint}.any?
      end
    end
  end
end
