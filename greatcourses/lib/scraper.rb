require "open-uri"
require "nokogiri"
require "csv"
require "json"

class Scraper
  CLASS_LIST_URL = "https://www.thegreatcourses.com/sitemap"

  def scrape_to_csv
    titledata = scrape_titles
    CSV.open("gc_titles.csv", "wb") do |csv|
      titledata.each { |title| csv << title }
    end
  end

  def scrape_to_json
    titledata = scrape_titles
    hash = titledata.each_with_object([]) do |t, a|
      a << {
        title: t[0],
        url: t[1]
      }
    end
    File.open("gc_titles.json","wb") do |f|
      f.write(hash.to_json)
    end
  end

  def scrape_to_all
    scrape_to_csv
    scrape_to_json
  end

  private

  def scrape_titles
    page = URI.parse(CLASS_LIST_URL).read
    doc = Nokogiri::HTML(page)
    title_elements = doc.search(".std ul")[2].children
    title_elements = title_elements.reject { |te| te.text.strip == "".freeze }
    title_elements.map do |title|
      [
        title.text,
        title.children.first.attr("href")
      ]
    end
  end
end
