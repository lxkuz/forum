class CollectGarbage
  LIFETIME = 1.minute

  def self.call
    Transaction.where('created_at < ?', LIFETIME.ago).delete_all
  end
end
