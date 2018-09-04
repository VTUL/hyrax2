module Importer
  # Import a csv file with one work per row. The first row of the csv should be a
  # header row.
  class CSVImporter

    attr_reader :manifest_file, :files_directory, :depositor, :collection_id

    def initialize(manifest_file, files_directory, depositor, collection_id)
      @manifest_file = manifest_file
      @files_directory = files_directory
      @depositor = depositor
      @collection_id = collection_id
    end

    # @return [Integer] count of objects created
    def import_all
      count = 0
      files_dir_array = Dir.glob(files_directory + "/**/Access")
      parser.each do |attributes|
        attrs = attributes.merge(deposit_attributes).merge(visibility_attributes)
        obj_id = attrs[:identifier].first
        obj_file_dir = files_dir_array.detect { |f_d| f_d.end_with?(obj_id + "/Access") }
        create_fedora_objects(attrs, obj_file_dir, collection_id)
        count += 1
      end
      count
    end

    private

    def deposit_attributes
      { depositor: depositor }
    end

    def visibility_attributes
      { visibility: "open" }
    end

    def parser
      CSVParser.new(manifest_file)
    end

    # Build a factory to create the objects in fedora.
    # @param [Hash<Symbol => String>] attributes
    def create_fedora_objects(attributes, files_directory, collection_id)
      factory_class = Factory.for("Item")
      f = factory_class.new(attributes, files_directory, collection_id)
      f.run
    end

  end
end
