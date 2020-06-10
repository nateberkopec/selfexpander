require "minitest"
require "minitest/autorun"
require "scraper"

class TestScraper < Minitest::Test
  def setup
    @scraper = Scraper.new
  end
end
