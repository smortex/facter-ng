# frozen_string_literal: true

describe Facts::Debian::Os::Release do
  describe '#call_the_resolver' do
    subject(:fact) { Facts::Debian::Os::Release.new }

    before do
      allow(Facter::Resolvers::OsRelease).to receive(:resolve).with(:release).and_return(value)
    end

    context 'when lsb_release installed' do
      let(:value) { '10.09' }
      let(:value_final) { { 'full' => '10.09', 'major' => '10', 'minor' => '9' } }

      it 'calls Facter::Resolvers::OsRelease' do
        fact.call_the_resolver
        expect(Facter::Resolvers::OsRelease).to have_received(:resolve).with(:release)
      end

      it 'returns release fact' do
        expect(fact.call_the_resolver).to be_an_instance_of(Array).and \
          contain_exactly(an_object_having_attributes(name: 'os.release', value: value_final),
                          an_object_having_attributes(name: 'operatingsystemmajrelease', value: value_final['major'],
                                                      type: :legacy),
                          an_object_having_attributes(name: 'operatingsystemrelease', value: value_final['full'],
                                                      type: :legacy))
      end
    end

    context 'when lsb_release uninstalled' do
      let(:value) { nil }

      it 'returns release fact as nil' do
        expect(fact.call_the_resolver).to be_an_instance_of(Facter::ResolvedFact).and \
          have_attributes(name: 'os.release', value: value)
      end
    end
  end
end
