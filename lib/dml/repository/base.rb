require 'dml/repository/dummy/collection'

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
        # - key {String|Integer} primary key
        #
        # Returns:
        #  - {NilClass} nil if record is not found
        #  - {Entity}   if record found
        #
        def fetch(key)
          _fetch(key)
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
          collection_class.new(array_or_dataset, entity)
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
        # Entity constructor must accept
        # a hash with attributes
        #
        # Example:
        #
        #     class User
        #       attr_accessor :id, :name
        #
        #       def initialize(attrs)
        #         @id, @name = attrs.values_at(:id, :name)
        #       end
        #     end
        #
        #     class UsersRepository
        #       entity User
        #     end
        #
        # Params:
        # - klass {Class} entity class
        #
        def entity(klass)
          @entity = klass
        end

        ##
        # Set collection class
        #
        # Collection class is responsible for converting
        # a collection of hashes to collection of entities
        # this allows us to create lazy collections.
        #
        # Collection constructor must accept an array or set
        # of hashes with attributes as a first param and entity
        # class as second param
        #
        # Example:
        #
        #     class User
        #       attr_accessor :id, :name
        #
        #       def initialize(attrs)
        #         @id, @name = attrs.values_at(:id, :name)
        #       end
        #     end
        #
        #     class Collection
        #       include Enumerable
        #       def initialize(collection, entity)
        #         @collection = collection.map { |attrs| Entity.new(attrs) }
        #       end
        #       def each(&block); @collection.each(&block); end
        #     end
        #
        #     Collection.new([{ id: 1, name: 'John' }], User)
        #     # => [#<User @id=1, @name="John">]
        #
        #     class UsersRepository
        #       entity User
        #       collection Collection
        #     end
        #
        # Params:
        # - klass {Class} collection class
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

      private

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

        def default_collection
          defined?(Dml::Collection) ? Dml::Collection : Dml::Repository::Dummy::Collection
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
