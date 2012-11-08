if defined?(User)
  Object.send(:remove_const, :User)
end
class User < ActiveRecord::Base; end

class ChangeUsers < ActiveRecord::Migration
  def change
    change_table :users do | t |
      t.string  :uid                # omniauth[:uid]
      t.text    :name,              # omniauth[:info]
                :nickname,
                :location,
                :description,
                :image,
                :urls
      t.text    :raw_info           # omniauth[:extra]

      t.change :email, :text
      t.change :first_name, :text
      t.change :last_name, :text
      t.change :phone, :text

      # Trackable
      t.integer  :sign_in_count
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip

      t.remove :login, :crypted_password, :salt, :remember_token, :remember_token_expires_at
    end
    User.find_each {|user| user.update_attribute :name, [user.first_name, user.mid_name, user.last_name].compact.join(' ')}
  end


end
