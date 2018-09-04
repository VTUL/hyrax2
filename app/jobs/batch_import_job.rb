class BatchImportJob < ApplicationJob

  queue_as Hyrax.config.ingest_queue_name

  def perform(args)
    importer = Importer::CSVImporter.new(args[:manifest_file],
                                         args[:files_directory],
                                         args[:depositor],
                                         args[:collection_id])
    importer.import_all
  end

end
