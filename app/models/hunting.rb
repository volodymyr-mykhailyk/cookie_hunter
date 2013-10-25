class Hunting

  ATTRIBUTES = %i(hunter stockpile hunters steal_bucket active_bonuses all_bonuses)
  attr_reader *ATTRIBUTES

  def initialize(hunter)
    @hunter = hunter
    @stockpile = @hunter.stockpile
    all_hunters = Hunter.select(:id, :email).where(nil).to_a
    all_hunters.delete(hunter)
    @hunters = all_hunters.map{|hunter| { id: hunter.id, email: hunter.email, cookies: hunter.cookies}}
    @steal_bucket = StealBucket.instance
    @active_bonuses = @hunter.active_bonuses
    @all_bonuses = Bonuses::Bonus.all_bonuses_for(@stockpile)
  end

end