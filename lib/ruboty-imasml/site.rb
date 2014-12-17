module RubotyImasml
  module Site
    DEFAULT = "http://millionlive.com"
    def self.ensure_site(url)
      if ENV['RUBOTY_IMASML_SITE']
        url.sub(/^#{Regexp.escape(DEFAULT)}/, ENV['RUBOTY_IMASML_SITE'])
      else
        url
      end
    end
  end
end
