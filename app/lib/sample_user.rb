class SampleUser
  def list_members(nickname, list_nm)
    tmember = []
    (1..3).each do |idx|
      list = SampleClient.new(idx, 'sample_memver_user' + idx.to_s)
      tmember.push(list)
    end
    tmember
  end
end
