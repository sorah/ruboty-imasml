require 'ruboty-imasml/card'
require 'open-uri'
require 'nokogiri'

module RubotyImasml
  class CardCollection
    LIST_PAGE = 'http://www.millionlive.com/index.php?cmd=list'

    def initialize(list_page = LIST_PAGE)
      @cards = nil
    end

    def cards
      @cards ||= begin
        page = Nokogiri::HTML(open(LIST_PAGE, 'r', &:read))

        page.search("#contents_wrapper ul li ul li a").map do |link|
          Card.new(link.inner_text, link[:href])
        end
      end
    end

    def search(text)
      cards.reject!(&:parse_failed?)

      case text
      when String
        cards.select { |card| card.name.include?(text) }
      else
        cards.select { |card| text === card.name }
      end
    end

    def query(text)
      cards = search(text)
      loop do
        card = cards.sample
        return nil unless card
        cards.delete(card)

        return card# if card.image_url
      end
    end
  end
end
