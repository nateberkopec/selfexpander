require "minitest"
require "minitest/autorun"
require "scraper"

class TestScraper < Minitest::Test
  def setup
    @scraper = Scraper.new
  end

  def test_trims_titles
    title = "  American Political Parties and Elections: A Very Short Introduction\n              (2nd edn)"
    new_title = @scraper.send(:trim_title, title)
    assert_equal "American Political Parties and Elections", new_title
  end
end
