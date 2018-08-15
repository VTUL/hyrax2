require 'importer/log_subscriber'

module Importer
  module Factory
    class ObjectFactory
      extend ActiveModel::Callbacks
      define_model_callbacks :save, :create
      class_attribute :klass
      attr_reader :attributes, :collection_ids, :files_directory, :object

      def initialize(attributes, files_dir = nil, collection_id)
        @attributes = attributes
        @files_directory = files_dir
        @collection_ids = Array(collection_id)
      end

      def run
        arg_hash = { id: attributes[:identifier].first, name: 'UPDATE', klass: klass }
        @object = find
        if @object
          ActiveSupport::Notifications.instrument('import.importer', arg_hash) { update }
        else
          ActiveSupport::Notifications.instrument('import.importer', arg_hash.merge(name: 'CREATE')) { create }
        end
        yield(object) if block_given?
        object
      end

      def update
        raise "Object doesn't exist" unless object
        run_callbacks(:save) do
          work_actor.update(environment(update_attributes))
        end
        log_updated(object)
      end

      def create
        attrs = create_attributes
        @object = klass.new
        run_callbacks :save do
          run_callbacks :create do
            klass == Collection ? create_collection(attrs) : work_actor.create(environment(attrs))           
          end
        end
        log_created(object)
      end

      def create_attributes
        transform_attributes
      end

      def update_attributes
        transform_attributes.except(:identifier)
      end

      def find
        if identifier = attributes[:identifier].first
          return find_by_identifier(identifier)
        end
      end

      def log_created(obj)
        msg = "Created #{klass.model_name.human} #{obj.id}"
        Rails.logger.info(msg)
      end

      def log_updated(obj)
        msg = "Updated #{klass.model_name.human} #{obj.id}"
        Rails.logger.info(msg)
      end

      def find_by_identifier(identifier)
        identifier_field_name = ActiveFedora.index_field_mapper.solr_name('identifier', :stored_sortable)
        results = klass.where(identifier_field_name => identifier)
        if results.count > 1
          raise Iawa::UnexpectedMultipleResultsError, I18n.t('iawa.unexpected_multiple_results', identifier: identifier)
        else
          results.first
        end
      end

      def parent_ids
        if parent = find_by_identifier(parent_identifier)
          parent.id
        end
      end

      private

      # Override if we need to map the attributes from the parser in
      # a way that is compatible with how the factory needs them.
      def transform_attributes
        sanitized_attributes
            .merge(file_attributes)
            .merge(collection_membership_attributes)
      end

      def sanitized_attributes
        permitted_attributes.each_with_object({}) do |(k, v), memo|
          if klass.delegated_attributes.key?(k)
            value = Array(v)
            memo[k] = klass.multiple?(k) ? value : value.first
          else
            memo[k] = v
          end
        end
      end

      def permitted_attributes
        attributes.slice(*permitted_attribute_names)
      end

      def permitted_attribute_names
        klass.properties.keys.map(&:to_sym) +
            [ :admin_set_id, :parent_identifiers, :edit_users, :edit_groups, :read_groups, :visibility ]
      end

      def collection_membership_attributes
        collection_ids.present? ? { member_of_collection_ids: collection_ids } : {}
      end

      def file_attributes
        files_directory.present? ? { remote_files: remote_files } : {}
      end

      def nesting_attributes
        parent_identifiers.present? ? { in_works_ids: parent_identifiers.map { |identifier| parent_id(identifier) } } : {}
      end

      def visibility_attributes
        visibility.present? ? { visibility: visibility.first } : {}
      end

      def import_user(attrs)
        attrs[:depositor].present? ? User.find_by_user_key(attrs[:depositor]) : User.batch_user
      end

      def remote_files
        Dir.glob(files_directory + "/*.tif").map do |f|
          Rails.logger.info("Files directory #{f}")
          { url: "file:#{f}", file_name: File.basename(f) }
        end
      end

      # @param [Hash] attrs the attributes to put in the environment
      # @return [Hyrax::Actors::Environment]
      def environment(attrs)
        Hyrax::Actors::Environment.new(@object, Ability.new(import_user(attrs)), attrs)
      end

      def work_actor
        Hyrax::CurationConcern.actor
      end

    end
  end
end
