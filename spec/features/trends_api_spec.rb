require 'spec_helper'
require 'rest-client'

describe "trends api", type: :feature do

  before do
    FactoryGirl.create(:trend1)
    FactoryGirl.create(:trend2)
    FactoryGirl.create(:topic1)
    FactoryGirl.create(:topic2)
    FactoryGirl.create(:stock1)
    FactoryGirl.create(:stock2)
    FactoryGirl.create(:contributor1)
    FactoryGirl.create(:contributor2)
  end

  context "xml format" do
    it "has time nodes at top" do
      visit "/api/v1/trends.xml"
      raw_xml = page.body
      xml = Nokogiri.parse(raw_xml)
      xml.remove_namespaces!

      expect(xml.xpath("//time//current").text).to eq("Wed, 31 Dec 2014 19:41:21 EST")
      expect(xml.xpath("//time//updates").text).to eq("20:00:00")
    end

    it "has complete set of nodes for first item" do
      visit "/api/v1/trends.xml"
      raw_xml = page.body
      xml = Nokogiri.parse(raw_xml)
      xml.remove_namespaces!
      expect(xml.xpath("//trends//trend//timelineItem//timestamp")[0].text).to eq("Wed, 31 Dec 2014 19:41:21 EST")
      expect(xml.xpath("//trends//trend//timelineItem//rank")[0].text).to eq("1")
      expect(xml.xpath("//trends//trend//topics//topic/name")[0].text).to eq("\n            #trend1 facebook topic\n          ")
      expect(xml.xpath("//trends//trend//description")[0].text).to eq("\n        trend1 description\n      ")
      expect(xml.xpath("//trends//trend//stocks//stock//timestamp")[0].text).to eq("Wed, 31 Dec 2014 19:41:21 EST")
      expect(xml.xpath("//trends//trend//stocks//stock//rank")[0].text).to eq("1")
      expect(xml.xpath("//trends//trend//stocks//stock//score")[0].text).to eq("10.7")
      expect(xml.xpath("//trends//trend//stocks//stock//contributors//contributor//vendor")[0].text).to eq("facebook")
      expect(xml.xpath("//trends//trend//stocks//stock//contributors//contributor//value")[0].text).to eq("")
      expect(xml.xpath("//trends//trend//stocks//stock//contributors//contributor//vendor_rank")[0].text).to eq("1")
    end
    it "has complete set of nodes for first item" do
      visit "/api/v1/trends.xml"
      raw_xml = page.body
      xml = Nokogiri.parse(raw_xml)
      xml.remove_namespaces!
      expect(xml.xpath("//trends//trend//timelineItem//timestamp")[1].text).to eq("Wed, 31 Dec 2014 19:41:21 EST")
      expect(xml.xpath("//trends//trend//timelineItem//rank")[1].text).to eq("2")
      expect(xml.xpath("//trends//trend//topics//topic/name")[1].text).to eq("\n            #trend2 twitter topic\n          ")
      expect(xml.xpath("//trends//trend//description")[1].text).to eq("\n        trend2 description\n      ")
      expect(xml.xpath("//trends//trend//stocks//stock//timestamp")[1].text).to eq("Wed, 31 Dec 2014 19:41:21 EST")
      expect(xml.xpath("//trends//trend//stocks//stock//rank")[1].text).to eq("2")
      expect(xml.xpath("//trends//trend//stocks//stock//score")[1].text).to eq("10.6")
      expect(xml.xpath("//trends//trend//stocks//stock//contributors//contributor//vendor")[1].text).to eq("twitter")
      expect(xml.xpath("//trends//trend//stocks//stock//contributors//contributor//value")[1].text).to eq("")
      expect(xml.xpath("//trends//trend//stocks//stock//contributors//contributor//vendor_rank")[1].text).to eq("2")
    end
  end
end