require 'open-uri'
require 'json'
require 'date'

module Sist02
  module_function
  def article_ref(naid)
    begin
      html = open("http://ci.nii.ac.jp/naid/#{naid}.json").read
      json = JSON.parser.new(html)
      hash = json.parse["@graph"][0]
      title =  hash["dc:title"][0]["@value"]
      creator = hash["dc:creator"][0][0]["@value"]
      publication_name = hash["prism:publicationName"][0]["@value"]
      year = hash["dc:date"].match(/\d{4}/)
      volume = hash["prism:volume"]
      number = hash["prism:number"]
      start_p = hash["prism:startingPage"]
      end_p = hash["prism:endingPage"]
      result = "#{creator}. #{title}. #{publication_name}. #{year}, #{volume}(#{number}), p. #{start_p}-#{end_p}."
    rescue => e
      result = e
    end
    return result
  end
end
