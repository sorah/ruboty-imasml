require 'nokogiri'
require 'open-uri'

module RubotyImasml
  class Card
    def initialize(name, link)
      @name, @link = name, link
      @image_url = nil
    end

    attr_reader :name, :link

    def parse_failed?
      @parsed && @image_url.nil?
    end

    def image_url
      parse
      @image_url
    end

    def serif
      parse
      @serif
    end
    
    private

    def parse
      return if @parsed
      @parsed = true

      page = Nokogiri::HTML(open(link, 'r', &:read))

      image = page.at('.ie5 table img')
      return false unless image
      @image_url = image[:src]

      serif_tag = page.at('.ie5 table tr:last-child td')
      if serif_tag
        @serif = serif_tag.inner_text
      end

      true
    rescue OpenURI::HTTPError
      nil
    end
  end
end
