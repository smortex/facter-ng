# frozen_string_literal: true

describe Facts::Aix::Mountpoints do
  describe '#call_the_resolver' do
    subject(:fact) { Facts::Aix::Mountpoints.new }

    let(:mountpoints_output) { { '/' => { device: '/dev/hd4', filesystem: 'jfs2', options: ['rw', 'log=/dev/hd8'] } } }
    let(:filesystem_sizes_output) do
      { '/' => { capacity: '18.61%', available_bytes: 1_747_865_600, device: '/dev/hd4',
                 used_bytes: 399_618_048, size_bytes: 2_147_483_648,
                 available: '1.63 GiB', used: '381.11 MiB', size: '2.00 GiB' } }
    end
    let(:result) do
      { '/' => { 'device' => '/dev/hd4', 'filesystem' => 'jfs2', 'options' => ['rw', 'log=/dev/hd8'],
                 'capacity' => '18.61%', 'available_bytes' => 1_747_865_600,
                 'used_bytes' => 399_618_048, 'size_bytes' => 2_147_483_648,
                 'available' => '1.63 GiB', 'used' => '381.11 MiB', 'size' => '2.00 GiB' } }
    end

    before do
      allow(Facter::Resolvers::Aix::Mountpoints).to \
        receive(:resolve).with(:mountpoints).and_return(mountpoints_output)
      allow(Facter::Resolvers::Aix::FilesystemsSizes).to \
        receive(:resolve).with(:sizes).and_return(filesystem_sizes_output)
    end

    it 'calls Facter::Resolvers::Aix::Mountpoints' do
      fact.call_the_resolver
      expect(Facter::Resolvers::Aix::Mountpoints).to have_received(:resolve).with(:mountpoints)
    end

    it 'calls Facter::Resolvers::Aix::FilesystemsSizes' do
      fact.call_the_resolver
      expect(Facter::Resolvers::Aix::FilesystemsSizes).to have_received(:resolve).with(:sizes)
    end

    it 'returns a resolved fact' do
      expect(fact.call_the_resolver).to be_an_instance_of(Facter::ResolvedFact).and \
        have_attributes(name: 'mountpoints', value: result)
    end
  end
end
