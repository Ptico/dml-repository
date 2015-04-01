module Dml
  module Repository
    ##
    # Class: provides base methods for Repository
    #
    class Base
      class << self

        ##
        # Static: get entity by primary key
        #
        # Params:
        # - id {String|Integer} primary key
        #
        # Returns:
        #  - {NilClass} nil if record is not found
        #  - {Entity}   if record found
        #
        def fetch(id)
          _fetch(id)
        end
        alias_method :[], :fetch

        ##
        # Static: save entities to database
        #
        # Params:
        # - records {Array|Entity} one entity or array of entities for saving
        #
        # Returns: {Array(Entity)} array of inserted items
        #
        def insert(records)
          _insert(Array(records))
        end
        alias_method :create, :insert

        ##
        # Static: update attributes of entities in the database
        #
        # Params:
        # - records {Array|Entity} one entity or array of entities for updating
        #
        # Returns: {Integer} count of inserted records
        #
        def update(records)
          _update(Array(records))
        end

        ##
        # Static: remove entities from database
        #
        # Params:
        # - records {Array|Entity} one entity or array of entities for deletion
        #
        # Returns: {Integer} count of deleted entities
        #
        def destroy(records)
          _destroy(records)
        end
        alias_method :delete, :destroy

        ##
        # Static: get collection from array or dataset
        #
        # Params:
        # - array_or_dataset {Array|Sequel::Dataset} Array of hashes or dataset
        #
        # Returns: {Collection}
        #
        def wrap(array_or_dataset)
          if collection_klass = collection_class || default_collection
            collection_class.new(array_or_dataset, @entity)
          elsif @entity
            array_or_dataset.map { |item| @entity.new(item) }
          else
            array_or_dataset
          end
        end

        ##
        # Get entity class
        #
        def entity_class
          @entity
        end

        ##
        # Get collection class
        #
        def collection_class
          @collection || default_collection
        end

        ##
        # Get relation name
        #
        def relation_name
          @relation
        end

        ##
        # Get primary key names
        #
        # Returns: {Array} of primary keys or empty array
        #
        def pk
          @primary_key || []
        end

      protected

        ##
        # Set entity class
        #
        def entity(klass)
          @entity = klass
        end

        ##
        # Set collection class
        #
        def collection(klass)
          @collection = klass
        end

        ##
        # Set relation name
        #
        def relation(name)
          @relation = name.to_sym
        end

        ##
        # Set primary key
        #
        def primary_key(*names)
          @primary_key = Array(names).flatten
        end

        ##
        # Private Static: make complex query for repositories
        #
        # Params:
        # - name    {Symbol} name of query
        # - options {Hash} options
        #   - default {Boolean} use default query (default: true)
        #   - first   {Boolean} return only first result
        #
        # Yields: block with query params
        #
        # Returns: {Collection}
        #
        def query(name, options={}, &block)
        end

      private

        def default_collection
          defined?(Dml::Collection) ? Dml::Collection : nil
        end

        ##
        # Private Abstract: fetch implementation
        #
        def _fetch(*)
          fail NotImplementedError
        end

        ##
        # Private Abstract: insert implementation
        #
        def _insert(*)
          fail NotImplementedError
        end

        ##
        # Private Abstract: update implementation
        #
        def _update(*)
          fail NotImplementedError
        end

        ##
        # Private Abstract: destroy implementation
        #
        def _destroy(*)
          fail NotImplementedError
        end

      end
    end
  end
end
