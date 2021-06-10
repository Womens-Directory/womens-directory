class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.strips_spaces_from_string_fields
    before_save :strip_strings
  end

  private

  def strip_strings
    self.class.columns.
      # for every `string` or `text`-type column,
      filter { |c| %i[string text].include? c.type }.
      each do |col|
        # get the existing value
        raw = send col.name.to_sym
        next unless raw

        # strip spaces and set the new value
        setter = "#{col.name}=".to_sym
        clean = raw.strip
        self.send setter, clean
      end
  end

  def name_as_slug
    name.downcase.gsub /[^-A-Za-z0-9]+/, '-'
  end
end
