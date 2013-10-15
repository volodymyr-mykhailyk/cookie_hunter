class StealBucket < Bucket

  def self.instance
    self.last || create
  end


end