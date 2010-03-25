Factory.sequence :gpoday_day do |n|
  Date.parse("01.01.2010") + n.weeks
end

Factory.define :gpoday do |gpoday|
  gpoday.date { Factory.next :gpoday_day }
end
