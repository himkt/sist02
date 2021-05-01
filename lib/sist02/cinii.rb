require 'open-uri'
require 'json'
require 'date'

module Sist02
  module CiNii
    # enable required program to call following functions
    module_function

    def article_ref naid

      begin

        url = "http://ci.nii.ac.jp/naid/#{naid}.json"
        content = get_content url
        common_info = get_common_info content
        volume = content["prism:volume"]
        number = content["prism:number"]
        start_p = content["prism:startingPage"]
        end_p = content["prism:endingPage"]
        result = "#{common_info["maker"]}. #{common_info["title"]}. #{common_info["publicationName"]}. #{common_info["year"]}, vol. #{volume}, no. #{number}, p. #{start_p}-#{end_p}."
      rescue => e
        result = e
      end
      return result
    end

    def book_ref ncid
      begin
        url = "http://ci.nii.ac.jp/ncid/#{ncid}.json"
        content = get_content url
        common_info = get_common_info content
        edition = content["prism:edition"]
        ris = URI.open("http://ci.nii.ac.jp/ncid/#{ncid}.ris").read
        edition = ris.match(/ET\s{2}-\s(.*)\r/) ? ris.match(/ET\s{2}-\s(.*)\r/)[1] : nil
        publisher = ris.match(/PB\s{2}-\s(.*)\r/) ? ris.match(/PB\s{2}-\s(.*)\r/)[1] : nil
        page = ris.match(/EP\s{2}-\s.*?(\d*?p)/) ? ris.match(/EP\s{2}-\s.*?(\d*?p)/)[1] : 'ページ数不明'
        result = "#{common_info["maker"]}. #{common_info["title"]}. #{edition}, #{publisher}, #{common_info["year"]}, #{page}." if edition
        result = "#{common_info["maker"]}. #{common_info["title"]}. #{publisher}, #{common_info["year"]}, #{page}." unless edition
      rescue => e
          result = e
      end
      return result
    end

    def dissertation_ref naid

      begin

        url = "http://ci.nii.ac.jp/naid/#{naid}.json"
        content = get_content url
        common_info = get_common_info content
        result = "#{common_info["maker"]}. #{common_info["title"]}. #{common_info["publisher"]}, #{common_info["year"]}, 博士論文."
      rescue => e
        result = e
      end
      return result
    end

    def get_content url
      html = URI.open(url).read
      json = JSON.parser.new(html)
      json.parse["@graph"][0]
    end


    def get_common_info content
      common_info = {}
      common_info["title"] = content["dc:title"][0]["@value"]
      common_info["publisher"] = content["dc:publisher"][0]["@value"]
      common_info["publicationName"] = content["prism:publicationName"][0]["@value"] if content["prism:publicationName"]
      common_info["year"] = content["dc:date"].match(/\d{4}/)
      author_ary = Array.new
      content["foaf:maker"].each do |item|
        author_ary << item["foaf:name"][0]["@value"].gsub(/(\s|　|,)+/, '')
      end
      common_info["maker"] = author_ary.join(", ")
      return common_info
    end

  end
end
