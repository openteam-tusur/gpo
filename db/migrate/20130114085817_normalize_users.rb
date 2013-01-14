class NormalizeUsers < ActiveRecord::Migration
  def up
    User.record_timestamps = false
    User.all.each do |user|
      [:email, :first_name, :middle_name, :last_name, :post, :float, :phone].each do |attribute|
        user.send("#{attribute}=", user.send(attribute).try(:squish))
      end
      user.save!
    end
  end
end
