require 'childprocess'
require 'tmpdir'
require 'fileutils'
require 'date'

require 'multi_json'
require 'selenium/webdriver/common'

module Selenium
  module WebDriver

    if MultiJson.respond_to?(:load)
      # @api private
      def self.json_load(obj)
        MultiJson.decode(obj)
        #MultiJson.load(obj)
      end
    else
      # @api private
      def self.json_load(obj)
        MultiJson.decode(obj)
      end
    end

  end
end
