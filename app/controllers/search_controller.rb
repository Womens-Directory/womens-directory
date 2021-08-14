class SearchController < ApplicationController
  class Result
    attr_reader :record

    def initialize(record)
      @record = record
    end

    def title
      @record.name
    end

    def content
      if @record.respond_to? :desc
        @record.desc
      else
        @record.description
      end
    end
  end

  def search
    @query = params[:q]
    @results = PgSearch.multisearch(@query).map do |raw|
      klass = raw.searchable_type.constantize
      record = klass.find raw.searchable_id
      Result.new record
    end
  end
end
