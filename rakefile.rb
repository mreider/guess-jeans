require_relative 'scraper'

task :default => :scrape

task :scrape do
  
   scraper = Scraper.new
   start_date = Date.parse('01-01-1983')
   end_date = Date.parse('01-01-1987')
   all_the_sundays = []
   (start_date..end_date).each do |day|
    if day.sunday?
        all_the_sundays.push(day)
    end
   end
   all_the_sundays.each do |date|
    sleep(1)
    songs = scraper.scrape(date)
    filename = "top100/" + date.to_s + ".json"
    File.open(filename,"w") do |f|
        f.write(JSON.pretty_generate(songs))
      end
    end
end

