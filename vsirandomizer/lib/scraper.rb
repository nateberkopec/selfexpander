require "open-uri"
require "nokogiri"
require "csv"
require "json"

class Scraper
  VSI_HOST = "https://www.veryshortintroductions.com"
  URL_BASE = "https://www.veryshortintroductions.com/browse?btog=book&isQuickSearch=true&pageSize=100&sort=titlesort&page="
  MAX_PAGES = 7

  def scrape_to_csv
    titledata = scrape_titles
    CSV.open("vsi_titles.csv", "wb") do |csv|
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
    File.open("vsi_titles.json","wb") do |f|
      f.write(hash.to_json)
    end
  end

  def scrape_to_all
    scrape_to_csv
    scrape_to_json
  end

  private

  def scrape_titles
    @pages ||= begin
      pages = download_all_pages
      pages.each_with_object([]) { |p, a| a.concat parse_page(p) }
    end
  end

  def download_all_pages
    (1..MAX_PAGES).map do |i|
      printf(".");
      URI.parse("#{URL_BASE}#{i}").read
    end
  end

  def parse_page(page)
    doc = Nokogiri::HTML(page)
    title_elements = doc.search(".title_abstract_popup")
    title_elements.map do |title|
      [
        trim_title(title.text),
        VSI_HOST + title.attribute("href").value
      ]
    end
  end

  def trim_title(title)
    title.split(":").first.strip
  end
end
