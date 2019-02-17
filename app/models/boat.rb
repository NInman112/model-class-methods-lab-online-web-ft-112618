class Boat < ActiveRecord::Base
  belongs_to  :captain
  has_many    :boat_classifications
  has_many    :classifications, through: :boat_classifications

  def self.first_five
    all.limit(5)
  end

  def self.dinghy
    all.where("length < 20")
  end

  def self.ship
    all.where("length >= 20")
  end

  def self.last_three_alphabetically
    all.order("name DESC").limit(3)
  end

  def self.without_a_captain
    all.where("captain_id is NULL")
  end

  def self.sailboats
    all.includes(:classifications).where(classifications: { name: "Sailboat" })
  end

  def self.with_three_classifications
    boats = all.joins(:classifications).select('boats.id').group('boats.id').count.find_all {|boat| boat[1] == 3}
    boats.flatten!.delete(3)
    self.where("id in (?)", boats)
  end

  def self.longest_boat
    all.order("length DESC").first
  end
end
