require 'importer'

class BatchImport
  include ActiveModel::Model

  attr_accessor :files_directory, :manifest_file, :depositor

  CONFIG_FILE = File.join(Rails.root, 'config', 'batch_import.yml')

  validates_presence_of :manifest_file, :files_directory
  validate :manifest_file_must_exist, if: Proc.new { manifest_file.present? }
  validate :files_directory_must_exist, if: Proc.new { files_directory.present? }
  validate :manifest_contents_must_be_valid, if: Proc.new { manifest_file_exists? && files_directory.present? }
  validate :depositor_must_exist, if: Proc.new { depositor.present? }
  validate :parent_collection_must_exist, if: Proc.new { files_directory.present? }

  def self.basepath
    if File.file?(CONFIG_FILE)
      if (config = YAML.load(File.read(CONFIG_FILE))) && config.is_a?(Hash)
        basepath = config.deep_symbolize_keys[:basepath]
      end
    end
    basepath ||= File.join(Rails.root, 'tmp', 'imports')
  end

  def initialize(attributes = {})
    attributes.each { |name, value| send("#{name}=", value) }
  end

  def persisted?
    false
  end

  def parser
    Importer::CSVParser.new(manifest_file_full_path)
  end

  def collection_id
    collection, id = parent_collection
    collection.id unless collection.nil?
  end

  def parent_collection
    c_n = files_directory.split("/").first
    collection_identifier = c_n[0...c_n.rindex('_')].gsub('_', '-') if c_n.include?('_')
    return Collection.where(identifier: [collection_identifier]).first,  collection_identifier
  end

  def manifest_file_exists?
    manifest_file.present? ? File.file?(manifest_file_full_path) : false
  end
 
  def manifest_file_full_path
    File.join(self.class.basepath, manifest_file)
  end

  def files_directory_full_path
    File.join(self.class.basepath, files_directory)
  end

  def manifest_file_must_exist
    unless manifest_file_exists?
      errors.add(:manifest_file, I18n.t('iawa.does_not_exist', target: manifest_file_full_path))
    end
  end

  def files_directory_must_exist
    unless Dir.exist?(files_directory_full_path)
      errors.add(:files_directory, I18n.t('iawa.does_not_exist', target: files_directory_full_path))
    end
  end

  def manifest_contents_must_be_valid
    manifest = Importer::CSVManifest.new(manifest_file_full_path, files_directory_full_path)
    unless manifest.valid?
      manifest.errors.full_messages.each do |msg|
        errors.add(:manifest_file, msg)
      end
    end
  end

   def depositor_must_exist
    unless User.find_by_user_key(depositor).present?
      errors.add(:depositor, "#{depositor} does not exist")
    end
  end

  def parent_collection_must_exist
    result, collection_identifier = parent_collection
    if result.nil?
      errors.add(:parent_collection, I18n.t('iawa.batch_import.parent_collection_does_not_exist', identifier: collection_identifier))
    end
  end
     
end
