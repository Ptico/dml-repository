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
        it 'returns dummy collection' do
          expect(subject).to be(Dml::Repository::Dummy::Collection)
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
    context 'when collection class defined' do
      xit 'instantiates collection class'
    end

    context 'when collection class not defined' do
      context 'when default_collection exists' do
        xit 'intantiates default collection class'
      end

      context 'when default_collection is nil' do
        context 'when entity set' do
          xit 'iterates over collection and wraps with entity'
        end

        context 'when entity not set' do
          xit 'just returns collection as it is'
        end
      end
    end
  end

end
