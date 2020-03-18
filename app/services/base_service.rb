class BaseService
  def self.call(options)
    new(options).call
  end
end
