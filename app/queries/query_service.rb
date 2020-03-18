class QueryService < BaseService
  def initialize(params)
    @params = params
  end

  protected

  attr_reader :params
end
