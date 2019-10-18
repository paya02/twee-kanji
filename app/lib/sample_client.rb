class SampleClient
  attr_accessor :name, :member_count, :description

  def initialize(idx)
    @name = 'サンプルリスト' + idx.to_s
    @member_count = 3
    @description = "サンプルのリスト#{idx.to_s}です。"
  end
end
