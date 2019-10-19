class SampleClient
  attr_accessor :name, :member_count, :description, :id

  def initialize(idx, id)
    @name = 'サンプルリスト' + idx.to_s
    @member_count = 3
    @description = "サンプルのリスト#{idx.to_s}です。"
    @id = id
  end
end
