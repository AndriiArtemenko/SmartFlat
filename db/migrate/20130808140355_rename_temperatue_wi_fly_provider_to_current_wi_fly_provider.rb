class RenameTemperatueWiFlyProviderToCurrentWiFlyProvider < ActiveRecord::Migration
  def up
    rename_table :temperatue_wi_fly_providers, :current_wi_fly_providers
  end

  def down
    rename_table :current_wi_fly_providers, :temperatue_wi_fly_providers
  end
end
