require 'open-uri'
require 'nokogiri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    index_page = Nokogiri::HTML(File.read(index_url))
    index_page.css("div.student-card").collect do |student|
      {
        :name => student.css("h4.student-name").text,
        :location => student.css("p.student-location").text,
        :profile_url => student.css("a")[0]['href']
      }
    end
  end

  def self.scrape_profile_page(profile_url)
    profile_page = Nokogiri::HTML(File.read(profile_url))
    social_links = profile_page.css("div.social-icon-container a")
    twitter = social_links.select {|l| l.css("img").attribute("src").value.include? "twitter"}
    linkedin = social_links.select {|l| l.css("img").attribute("src").value.include? "linkedin"}
    github = social_links.select {|l| l.css("img").attribute("src").value.include? "github"}
    blog = social_links.select {|l| l.css("img").attribute("src").value.include? "rss"}
    hash = {}
    if twitter[0]
      hash[:twitter] = twitter[0]['href']
    end
    if linkedin[0]
      hash[:linkedin] = linkedin[0]['href']
    end
    if github[0]
      hash[:github] = github[0]['href']
    end
    if blog[0]
      hash[:blog] = blog[0]['href']
    end
    hash[:profile_quote] = profile_page.css("div.profile-quote").text
    hash[:bio] = profile_page.css("div.bio-content p").text
    hash
  end

end
