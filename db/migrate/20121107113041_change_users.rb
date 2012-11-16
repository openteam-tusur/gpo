if defined?(User)
  Object.send(:remove_const, :User)
end
class User < ActiveRecord::Base; end

class ChangeUsers < ActiveRecord::Migration
  def change
    change_table :users do | t |
      t.string  :uid                # omniauth[:uid]

      t.rename :mid_name, :middle_name
      # Trackable
      t.integer  :sign_in_count
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip

      t.remove :login, :crypted_password, :salt, :remember_token, :remember_token_expires_at
    end
  end


end
