require 'nokogiri'
require 'redis'
require 'httparty'
require 'pry'
require 'date'
@@api = ENV["YT_API"]

class Scraper
    attr_reader :url, :date
    
    def parse_url(date)
        @url = "https://www.billboard.com/charts/hot-100/#{date}"
        unparsed_page = HTTParty.get(url)
        Nokogiri::HTML(unparsed_page)
    end

    def scrape(year,week)
        date = Date.commercial(year, week, 1).strftime("%Y-%m-%d")
        @date = date
        parsed_page = parse_url(date)
        songs = parsed_page.css('ol.chart-list__elements li')
        top100 = []
        songs.each_with_index do |song,i|
            top100[i] = {}
            top100[i]['title'] = song.css('.chart-element__information__song').text
            top100[i]['artist'] =  song.css('.chart-element__information__artist').text
        end
        return top100
    end

    def get_vids(top100)
        yt_url = "https://www.googleapis.com/youtube/v3/search"
        top100.each { |i| 
        search_query = i['artist'] + i['title']
        options = { query: { part: "snippet", q: search_query, key: @@api },format: :json}
        results = HTTParty.get(yt_url,options)
        puts results
        exit
        }
    end
end