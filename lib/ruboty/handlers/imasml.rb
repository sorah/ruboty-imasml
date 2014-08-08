require "ruboty-imasml/version"
require 'ruboty-imasml/card_collection'
require 'ruboty-imasml/card'
require 'ruboty/handlers/base'
require 'net/http'
require 'json'
require 'uri'

module Ruboty
  module Handlers
    class Imasml < Base
      VERSION = RubotyImasml::VERSION
      PPDB_API = URI("http://ppdb.sekai.in/api/2/idol.json")
      IMG_URL = "http://125.6.169.35/idolmaster/image_sp/card/%s/%s.jpg"

      on(/imasml(?:\s+?(?<listmode>list))?(?:\s+?me)?\s+(?<query>.+)$/, name: 'imasml', description: 'find imasml cards')
      on(/imasml flush cache/, name: 'imasml_flush', description: 'flush imasml query cache')

      def imasml(message)
        return imasml_list(message) if message[:listmode] == 'list'
        card = card_collection.query(message[:query])
        if card
          message.reply(card.name)
          message.reply(card.serif) if card.serif
          message.reply(card.image_url)
        else
          message.reply("not found")
        end
      end

      def imasml_list(message)
        message.reply card_collection.search(message[:query]).map(&:name).join("\n")
      end

      def imasml_flush(message)
        @card_collection = nil
        message.reply "Flushed"
      end

      private

      def card_collection
        @card_collection ||= RubotyImasml::CardCollection.new
      end
    end
  end
end
