class DeviseCreateMalladmins < ActiveRecord::Migration
  def self.up
    create_table(:malladmins) do |t|
      t.database_authenticatable :null => false
      t.recoverable
      t.rememberable
      t.trackable

      # t.encryptable
      # t.confirmable
      # t.lockable :lock_strategy => :failed_attempts, :unlock_strategy => :both
      # t.token_authenticatable


      t.timestamps
    end

    add_index :malladmins, :email,                :unique => true
    add_index :malladmins, :reset_password_token, :unique => true
    # add_index :malladmins, :confirmation_token,   :unique => true
    # add_index :malladmins, :unlock_token,         :unique => true
    # add_index :malladmins, :authentication_token, :unique => true
  end

  def self.down
    drop_table :malladmins
  end
end
