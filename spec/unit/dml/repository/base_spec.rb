RSpec.describe Dml::Repository::Base do

  describe 'entity class' do
    subject { repo.entity_class }

    context 'when set' do
      let(:repo) do
        Class.new(described_class) do
          entity(Struct.new(:id, :name))
        end
      end

      it 'returns entity class' do
        entity = subject.new(2, 'John')

        expect(entity.id).to   equal(2)
        expect(entity.name).to eql('John')
      end
    end

    context 'when not set' do
      let(:repo) { Class.new(described_class) }

      it 'returns nil' do
        expect(subject).to be(nil)
      end
    end
  end

  describe 'collection class' do
    subject { repo.collection_class }

    context 'when set' do
      let(:collection) { Class.new(Array) }

      let(:repo) do
        collection_class = collection

        Class.new(described_class) do
          collection(collection_class)
        end
      end

      it 'returns collection class' do
        expect(subject).to equal(collection)
      end
    end

    context 'when not set' do
      let(:repo) { Class.new(described_class) }

      context 'when Dml::Collection defined' do
        before(:each) do
          class Dml::Collection; end
        end

        after(:each) do
          Dml.send(:remove_const, 'Collection')
        end

        it 'returns Dml::Collection' do
          expect(subject).to be(Dml::Collection)
        end
      end

      context 'when Dml::Collection not defined' do
        it 'returns nil' do
          expect(subject).to be(nil)
        end
      end
    end
  end

  describe 'relation name' do
    subject { repo.relation_name }

    context 'when string' do
      let(:repo) do
        Class.new(described_class) do
          relation('users')
        end
      end

      it 'returns symbol' do
        expect(subject).to equal(:users)
      end
    end

    context 'when symbol' do
      let(:repo) do
        Class.new(described_class) do
          relation(:users)
        end
      end

      it 'returns symbol' do
        expect(subject).to equal(:users)
      end
    end

    context 'when not set' do
      let(:repo) { Class.new(described_class) }

      it 'returns nil' do
        expect(subject).to be(nil)
      end
    end
  end

  describe 'primary key' do
    subject { repo.pk }

    context 'when single key' do
      let(:repo) do
        Class.new(described_class) do
          primary_key(:id)
        end
      end

      it 'returns array with single key' do
        expect(subject).to eql([:id])
      end
    end

    context 'when array' do
      let(:repo) do
        Class.new(described_class) do
          primary_key([:id, :email])
        end
      end

      it 'returns array with both keys' do
        expect(subject).to eql([:id, :email])
      end
    end

    context 'when params array' do
      let(:repo) do
        Class.new(described_class) do
          primary_key(:id, :email)
        end
      end

      it 'returns array with both keys' do
        expect(subject).to eql([:id, :email])
      end
    end

    context 'when not set' do
      let(:repo) { Class.new(described_class) }

      it 'returns empty array' do
        expect(subject).to eql([])
      end
    end
  end

  describe '.wrap' do
    subject do
      repo.wrap(array_or_dataset)
    end

    context 'when collection class defined' do
      context 'when entity set' do
        let(:entity)           { Struct.new(:id, :name) }
        let(:collection)       { Class.new(Struct.new(:collection, :entity)) }
        let(:array_or_dataset) { [entity.new(1, 'Test1'), entity.new(2, 'Test2')] }

        let(:repo) do
          collection_class = collection
          entity_class     = entity

          Class.new(described_class) do
            entity(entity_class)
            collection(collection_class)
          end
        end

        it 'instantiates collection class' do
          expect(subject.class).to eql(collection)
        end
      end

      context 'when entity not set' do
        let(:collection)       { Class.new(Struct.new(:collection, :entity)) }
        let(:array_or_dataset) { ['Test1', 'Test2'] }

        let(:repo) do
          collection_class = collection

          Class.new(described_class) do
            collection(collection_class)
          end
        end

        it 'instantiates collection class' do
          expect(subject.class).to eql(collection)
        end
      end
    end

    context 'when collection class not defined' do
      context 'when default_collection exists' do
        let(:entity)           { Struct.new(:id, :name) }
        let(:array_or_dataset) { [entity.new(1, 'Test1'), entity.new(2, 'Test2')] }

        let(:repo) do
          entity_class = entity

          Class.new(described_class) do
            entity(entity_class)
          end
        end

        before(:each) do
          class Dml::Collection
            def initialize(array_or_dataset, entity); end
          end
        end

        after(:each) { Dml.send(:remove_const, 'Collection') }

        it 'intantiates default collection class' do
          expect(subject.class).to eql(Dml::Collection)
        end
      end

      context 'when default_collection is nil' do
        let(:array_or_dataset) { ['hello', 'world'] }

        context 'when entity set' do
          let(:entity) { Struct.new(:entity) }

          let(:repo) do
            entity_class = entity

            Class.new(described_class) do
              entity(entity_class)
            end
          end

          it 'iterates over collection and wraps with entity' do
            expect(subject.first.class).to eql(entity)
          end
        end

        context 'when entity not set' do
          let(:repo) do
            Class.new(described_class)
          end

          it 'just returns collection as it is' do
            expect(subject).to eql(array_or_dataset)
          end
        end
      end
    end
  end

end
