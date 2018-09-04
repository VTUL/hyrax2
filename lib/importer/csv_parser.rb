module Importer
  class CSVParser
    include Enumerable

    attr_reader :file_name

    def initialize(file_name)
      @file_name = file_name
    end

    def headers
      @headers = as_csv_table.headers.compact
    end

    def each(&_block)
      as_csv_table.each do |row|
        yield attributes(row)
      end
    end

    private

    # for each row
    def attributes(row)
      {}.tap do |parsedHash|
        row.each do |header, val|
          extract_field(header, val, parsedHash)
        end
      end
    end

    def extract_field(header, val, parsedHash)
      unless val.blank?
        case header
        when 'Collection Identifier'
          parsedHash[:collection_id] = val
        when 'Circa'
          if val == 'Yes'
            parsedHash[:date_created] = "Circa "  
          end
        when 'Start Date'
          parsedHash[:date_created] ||= ""
          parsedHash[:date_created] += val 
        when 'End Date'
          parsedHash[:date] = val
        when 'Type'
          extract_multi_value_field(header, val, parsedHash, key = 'resource_type')
        when 'Tags'
          extract_multi_value_field(header, val, parsedHash, key = 'keyword')
        when 'Is Part Of'
          extract_multi_value_field(header, val, parsedHash, key = 'location')
        when 'Related URL'
          extract_multi_value_field(header, val, parsedHash, key = 'related_url')
        else
          extract_multi_value_field(header, val, parsedHash)
        end
      end
    end

    def extract_multi_value_field(header, val, parsedHash, key = nil)
      key ||= header.downcase
      key = key.to_sym
      parsedHash[key] ||= []
      separator = Rails.configuration.csv_mv_separator
      parsedHash[key] += val.split(separator).map(&:strip)
    end

    def as_csv_table
      @csv_table ||= CSV.read(file_name, headers: true)
    end
  end
end
