# frozen_string_literal: true

# respecting rubocop guidelines and current facter namespacing structure
# this should reside under: spec/facter/fedora/ruby_version_spec.rb

describe Facter::Fedora::RubyVersion do
  describe '#call_the_resolver' do
    subject(:fact) { Facter::Fedora::RubyVersion.new }

    let(:version) { '2.6.3' }

    before do
      allow(Facter::Resolvers::Ruby).to \
        receive(:resolve).with(:version).and_return(version)
    end

    it 'calls Facter::Resolvers::Ruby' do
      fact.call_the_resolver
      expect(Facter::Resolvers::Ruby).to have_received(:resolve).with(:version)
    end

    it 'returns a resolved fact' do
      expect(fact.call_the_resolver).to be_an_instance_of(Facter::ResolvedFact).and \
        have_attributes(name: 'ruby.version', value: version)
    end
  end
end
