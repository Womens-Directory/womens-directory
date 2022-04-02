class SearchController < ApplicationController
  # controller for search bar
  class Result
    # record is the raw object behind the search result
    attr_reader :record

    def initialize(record)
      @record = record
    end

   # name of the location or org searched
    def title
      @record.name
    end

    # .respond_to? ask if the record has the method :desc or description, want to use both
    # content is the description of location or org
    def content
      if @record.respond_to? :desc
        @record.desc
      else
        @record.description
      end
    end
  end

  # query is what person searched in search bar
  # results uses PgSearch (searches everything in Postgres, is easier and faster then just using ruby
  # logic like .find b. you have to go through every row in database using that
  # for each raw search result, turn into a Result object
  def search
    @query = params[:q]
    @results = PgSearch.multisearch(@query).map do |raw|
      # klass is the string that represents the type of result this is, since we can't do anything with
      # a string,
      # raw.searchable_type = "Location"
      # raw.searchable_type.constantize = Location
      # klass = Location, need class this location came from
      klass = raw.searchable_type.constantize
      record = klass.find raw.searchable_id
      Result.new record
    end
  end
end
