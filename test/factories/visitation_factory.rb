Factory.define :visitation do |visitation|
  visitation.association :gpoday, :factory => :gpoday
  visitation.association :participant, :factory => :participant
  visitation.rate 1
end
