module Importer
  class CSVManifest
    include ActiveModel::Validations

    attr_reader :files_directory, :manifest_file
    validate :manifest_file_type
    validate :metadata_headers
    validate :controlled_vocab_values

    def self.controlled_vocab_fields
      ["medium", "resource_type", "keyword"]
    end

    def self.controlled_vocab_headers
      @controlled_vocab_headers ||= controlled_vocab_fields.map(&:to_sym)
    end

    def self.controlled_vocab_hash
      @controlled_vocab_hash =
        controlled_vocab_fields.inject({}) do |hash, vocab|
          hash.update(vocab => ControlledVocab.where(field: vocab + "_sim").all.map { |entry| entry.name } )
        end
    end

    def self.controlled_vocab_names(vocab_field)
      controlled_vocab_hash[vocab_field]
    end

    def self.valid_headers
      ["Identifier", "Collection Identifier", "Title", "Circa", "Start Date", "End Date", 
       "Description", "Subject", "Type", "Medium", "Format", "Creator", "Source", "Is Part Of",
       "Language", "Coverage", "Tags", "Related URL", "Contributor", "file"]  
    end

    def initialize(manifest_file, files_directory)
      @manifest_file = manifest_file
      @files_directory = files_directory
    end

    def parser
      @parser ||= CSVParser.new(manifest_file)
    end

    def manifest_file_type
      unless File.extname(manifest_file) == ".csv"
        errors.add(:file, I18n.t('iawa.batch_import.unknow_file_type', file: manifest_file))
      end
    end

    def metadata_headers
      parser.headers.each do |header|
        unless self.class.valid_headers.include?(header)
          errors.add(:base, I18n.t('iawa.batch_import.invalid_metadata_header', header: header))
        end
      end
    end

    def controlled_vocab_values
      parser.each_with_index do |attributes, idx|
        attributes.each do |field, values|
          if self.class.controlled_vocab_headers.include?(field)
            values.each do |value|
              validate_attribute_value(field, value, idx)
            end
          end
        end
      end
    end

    def validate_attribute_value(field, value, idx)
      unless self.class.controlled_vocab_names(field.to_s).include?(value)
        errors.add(field, I18n.t('iawa.batch_import.invalid_metadata_value', row: "#{idx+2}", field: field, value: value))
      end
    end

  end
end
