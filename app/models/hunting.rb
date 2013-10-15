class Hunting

  JSON_ATTRIBUTES = %i(hunter stockpile hunters steal_bucket active_bonuses available_bonuses)
  attr_reader *JSON_ATTRIBUTES

  def initialize(hunter)
    @hunter = hunter
    @stockpile = @hunter.stockpile
    all_hunters = Hunter.select(:id, :email).where(nil).to_a
    all_hunters.delete(hunter)
    @hunters = all_hunters.map{|hunter| { id: hunter.id, email: hunter.email, cookies: hunter.cookies}}
    @steal_bucket = StealBucket.instance
    @active_bonuses = @hunter.active_bonuses
    @available_bonuses = Bonus.get_available_bonuses(@hunter.cookies)
  end

end