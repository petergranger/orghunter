require 'json'
module Orghunter
  class Search
    attr_reader :results, :response

    def initialize(args)
      @ein          = args[:ein]          ? "&ein=#{args[:ein]}"                  : 
      @search_term  = args[:search_term]  ? "&searchTerm=#{args[:search_term]}"   : ''
      @city         = args[:city]         ? "&city=#{args[:city]}"                : ''
      @state        = args[:state]        ? "&state=#{args[:state]}"              : ''
      @zip_code     = args[:zip_code]     ? "&zipCode=#{args[:zip_code]}"         : ''
      @category     = args[:category]     ? "&category=#{args[:category]}"        : ''
      @eligible     = args[:eligible]     ? "&eligible=1"                         : ''
      @rows         = args[:rows]         ? "&rows=#{args[:rows]}"                : ''
      @start        = args[:start]        ? "&start=#{args[:start]}"              : ''
      query_api
    end

    def create_string
      @query_url = "http://data.orghunter.com/v1/charitysearch?user_key=#{Orghunter.configuration.api_key}#{@ein}#{@search_term}#{@city}#{@state}#{@zip_code}#{@category}#{@eligible}#{@rows}#{@start}"
    end

    def query_api
      create_string
      response = Net::HTTP.get_response(URI(@query_url))
      response_json = JSON.parse(response.body)
      @results = create_charities(response_json)
    end

    def create_charities(charity_hashes)
      charity_hashes.map{|charity_hash| Charity.new(charity_hash)}
    end
  end
end