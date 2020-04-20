require 'spec_helper'

describe Scraper do
    it "gets the billboard top 100 for Feb 11th 1984" do
        scraper = Scraper.new
        date = Date.iso8601("1984-02-11")
        songs = scraper.scrape(date)
        expect(songs.length).to eq(100)
    end

    it "checks that Karma Chameleon is number 1" do
        scraper = Scraper.new
        date = Date.iso8601("1984-02-11")
        songs = scraper.scrape(date)
        expect(songs[0]['title']).to eq("Karma Chameleon")
    end

    it "gets some videos back from YouTube" do
        scraper = Scraper.new
        date = Date.iso8601("1986-04-19")
        songs = scraper.scrape(date)
        vids = scraper.get_vids(songs)
        vids_json = JSON.parse(vids.body)
        expect(vids_json["kind"]).to eq("youtube#searchListResponse")
    end
end