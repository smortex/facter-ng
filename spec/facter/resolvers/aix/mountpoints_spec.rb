# frozen_string_literal: true

describe Facter::Resolvers::Aix::Mountpoints do
  let(:mountpoints) do
    { '/' => { device: '/dev/hd4', filesystem: 'jfs2', options: ['rw', 'log=/dev/hd8'] },
      '/opt' => { device: '/dev/hd10opt', filesystem: 'jfs2', options: ['rw', 'log=/dev/hd8'] },
      '/usr' => { device: '/dev/hd2', filesystem: 'jfs2', options: ['rw', 'log=/dev/hd8'] } }
  end

  before do
    allow(Open3).to receive(:capture2).with('mount 2>/dev/null').and_return(load_fixture('mount').read)
  end

  it 'returns mountpoints' do
    result = Facter::Resolvers::Aix::Mountpoints.resolve(:mountpoints)

    expect(result).to eq(mountpoints)
  end
end
