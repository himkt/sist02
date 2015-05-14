require 'open-uri'
require 'json'
require 'date'

module Sist02
  module CiNii
    module_function
    def article_ref(naid)
      begin

        bib = Hash.new

        data = JSON.parse(open("http://ci.nii.ac.jp/naid/#{naid}.json").read)["@graph"][0]

        language = data["dc:language"]

        creator_raw = data["dc:creator"]
        creator = ''
        separator = (language == 'JPN') ? "," : ";"
        creator_raw.each do |item|
          creator += "#{item[0]["@value"]}#{separator} "
        end
        bib[:creator] = creator.sub(/\,\s$/,'')

        title_data = data["dc:title"][0]
        bib[:title] = title_data["@value"]

        bib[:publication_name] = data["prism:publicationName"][0]["@value"]

        bib[:year] = data["dc:date"].match(/\d{4}/)

        bib[:volume] = "vol. #{data['prism:volume']}"

        bib[:number] = "no. #{data['prism:number']}"

        bib[:page] = "p. #{data['prism:startingPage']}-#{data['prism:endingPage']}"

        result = ''
        bib.each do |attr,value|
          separator = (attr.to_s =~ /creator|title|publication_name/) ? '.' : ','
          result += "#{value}#{separator} "
        end
        result = result.sub(/\,\s$/, '.')

      rescue

        puts 'error occured. failed to make bibliographic data'

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
        pages = "ページ数不明" if pages == ''
        result = "#{author}. #{title}. #{edition}, #{publisher}, #{year}, #{pages}." unless edition == nil
        result = "#{author}. #{title}. #{publisher}, #{year}, #{pages}." if edition == nil # for bibliographic information that doesn't have edition display
      rescue => e
          result = e
      end
      return result
    end
  end
end
