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
          _fetch
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
          _destroy
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
          collection.new(array_or_dataset, entity)
        end

      protected

        ##
        # Set entity class
        #
        def entity
        end

        ##
        # Set collection class
        #
        def collection
        end

        ##
        # Set relation name
        #
        def relation
        end

        ##
        # Set primary key
        #
        def primary_key
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
