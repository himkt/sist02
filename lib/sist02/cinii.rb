require 'open-uri'
require 'json'
require 'date'

module Sist02
  module CiNii
    module_function
    def article_ref(naid)
      begin
        html = open("http://ci.nii.ac.jp/naid/#{naid}.json").read
        json = JSON.parser.new(html)
        hash = json.parse["@graph"][0]
        title =  hash["dc:title"][0]["@value"]
        creator_raw = hash["dc:creator"]
        creator = ''
        creator_raw.each do |item|
          creator += "#{item[0]["@value"]}, "
        end
        creator = creator.gsub(/\,\s$/, '')
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

    def book_ref(ncid)
      begin
        html = open("http://ci.nii.ac.jp/ncid/#{ncid}.json").read
        json = JSON.parser.new(html)
        hash = json.parse["@graph"][0]
        title = hash["dc:title"][0]["@value"]
        publisher = hash["dc:publisher"][0]
        year = hash["dc:date"].match(/\d{4}/)
        edition = hash["prism:edition"]
        author_ary = Array.new
        hash["foaf:maker"].each do |item|
          author_ary << item["foaf:name"][0]["@value"].gsub(/(\s|　|,)+/, '')
        end
        author = author_ary.join(", ")

        ris = open("http://ci.nii.ac.jp/ncid/#{ncid}.ris").read
        pages = ris.match(/EP  - ([a-z]*, )?\d+p/).to_s.gsub(/EP  - /, '')

        result = "#{author}. #{title}. #{edition}, #{publisher}, #{year}, #{pages}."
      rescue => e
          result = e
      end
      return result
    end
  end
end
