require 'devcenter-parser'

module Devcenter

  class ArticleFile

    attr_reader :metadata, :html, :content, :parsing_error, :toc

    def initialize(opts = {})
      @metadata = opts[:metadata] || OpenStruct.new
      @content = opts[:content] || ''
      begin
        @html = ::DevcenterParser.to_html(@content, :github)
      rescue Exception => e
        @parsing_error = e.to_s
        @html = ''
      end
      @toc = Nokogiri::HTML(@html).search('h2')
    end

    def self.read(src_path)
      src = IO.read(src_path)
      metadata_yaml, content = src.split(/\r*\n\r*\n/, 2)
      metadata = OpenStruct.new Psych.load(metadata_yaml)
      new(metadata: metadata, content: content)
    end

  end

end
