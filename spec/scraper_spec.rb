require 'spec_helper'

describe Scraper do

    it "gets the billboard top 100 for the 1st week of April in 1986" do
        scraper = Scraper.new
        songs = scraper.scrape(1986,14)
        expect(songs.length).to eq(100)
    end

    it "checks that Rock me Amadeus is number 1" do
        scraper = Scraper.new
        songs = scraper.scrape(1986,14)
        expect(songs[0]['title']).to eq("Rock Me Amadeus")
    end

    it "gets some videos back from YouTube" do
        scraper = Scraper.new
        songs = scraper.scrape(1986,14)
        vids = scraper.get_vids(songs)
        vids_json = JSON.parse(vids.body)
        puts vids_json
    end
end