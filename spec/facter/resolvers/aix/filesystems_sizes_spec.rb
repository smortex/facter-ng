# frozen_string_literal: true

describe Facter::Resolvers::Aix::FilesystemsSizes do
  let(:sizes) do
    { '/usr' => { device: '/dev/hd2', available: '2.84 GiB', available_bytes: 3_049_021_440, capacity: '43.21%',
                  size: '5.00 GiB', size_bytes: 5_368_709_120, used: '2.16 GiB', used_bytes: 2_319_687_680 },
      '/' => { device: '/dev/hd4', available: '1.63 GiB', available_bytes: 1_747_865_600, capacity: '18.61%',
               size: '2.00 GiB', size_bytes: 2_147_483_648, used: '381.11 MiB', used_bytes: 399_618_048 } }
  end

  before do
    allow(Open3).to receive(:capture2).with('df -P 2>/dev/null').and_return(load_fixture('df').read)
  end

  it 'returns filesystems sizes' do
    result = Facter::Resolvers::Aix::FilesystemsSizes.resolve(:sizes)

    expect(result).to eq(sizes)
  end
end
