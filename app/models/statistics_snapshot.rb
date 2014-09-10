class StatisticsSnapshot < ActiveRecord::Base
  attr_accessible :data

  serialize :data, Hash

  def self.build_and_save
    data = { :global =>  Stat.global.inject({}) { |h, e| h[e.key] = e.value; h  } }

    Chair.all.inject(data) do |hash, chair|
      hash[chair.id] = Stat.for_chair(chair).inject({}) { |h, e| h[e.key] = e.value; h  }

      hash
    end

    create :data => data
  end
end
