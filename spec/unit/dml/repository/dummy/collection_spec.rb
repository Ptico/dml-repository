RSpec.describe Dml::Repository::Dummy::Collection do
  subject { described_class.new(collection, entity) }

  let(:entity) do
    Class.new do
      attr_accessor :id, :name

      def initialize(attrs)
        @id, @name = attrs.values_at(:id, :name)
      end
    end
  end

  let(:collection) do
    [
      { id: 1, name: 'John' },
      { id: 2, name: 'Jane' }
    ]
  end

  it 'should wrap attributes' do
    subject.each do |en|
      expect(en).to be_instance_of(entity)
    end
  end

  it 'should iterate over collection' do
    subject.each_with_index do |en, i|
      expect(en.id).to   equal(collection[i][:id])
      expect(en.name).to eql(collection[i][:name])
    end
  end

  it '#first' do
    expect(subject.first.id).to equal(1)
  end

  it '#last' do
    expect(subject.last.id).to equal(2)
  end
end
