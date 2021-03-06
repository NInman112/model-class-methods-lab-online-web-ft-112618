class Captain < ActiveRecord::Base
  has_many :boats

  def self.catamaran_operators
    all.includes(boats: :classifications).where(classifications: { name: "Catamaran" })
  end

  def self.sailors
    all.includes(boats: :classifications).where(classifications: { name: "Sailboat" }).uniq
  end

  def self.talented_seafarers
    captains = all.includes(boats: :classifications).where(classifications: { name: "Motorboat" }).pluck(:id) & self.sailors.pluck(:id)
    where("id IN (?)", captains)
  end

  def self.non_sailors
    where.not("id IN (?)", self.sailors.pluck(:id))
  end
end
