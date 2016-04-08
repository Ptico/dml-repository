module Dml
  module Repository
    module Dummy
      ##
      # Class: very basic collection implementation
      #
      class Collection
        include Enumerable
        extend Forwardable

        def_delegators :collection, :each, :last

        attr_reader :collection

      private

        ##
        # Constructor:
        #
        # Params:
        # - collection {Array|Set} collection of attributes
        # - entity     {Class}     entity class
        #
        def initialize(collection, entity)
          @collection = collection.map { |attrs| entity.new(attrs) }
        end

      end
    end
  end
end
