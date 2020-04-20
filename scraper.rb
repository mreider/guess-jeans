require 'nokogiri'
require 'redis'
require 'httparty'
require 'pry'
require 'date'
require 'cgi'

class Scraper
    attr_reader :url, :date
    
    def parse_url(date)
        @url = "https://www.billboard.com/charts/hot-100/#{date}"
        unparsed_page = HTTParty.get(url).body
        parsed_page = Nokogiri::HTML(unparsed_page)
        return parsed_page
    end

    def scrape(date)
        date = date.strftime("%Y-%m-%d")
        @date = date
        parsed_page = parse_url(date)
        songs = parsed_page.css('ol.chart-list__elements li')
        top100 = []
        songs.each_with_index do |song,i|
            top100[i] = {}
            rank = i + 1
            top100[i]['rank'] = rank
            top100[i]['date'] = date
            top100[i]['title'] = song.css('.chart-element__information__song').text
            top100[i]['artist'] =  song.css('.chart-element__information__artist').text
            query_unencoded = top100[i]['title'] + " " + top100[i]['artist'] + " " + "MTV"
            query = CGI.escape(query_unencoded)
            top100[i]['link'] = "https://www.youtube.com/results?search_query=" + query + "&sp=CAM%253D"
        end
        return top100
    end

end