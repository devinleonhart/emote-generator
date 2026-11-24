# This migration comes from tailnet_mcp (originally 20261124000000)
class CreateMcpTokens < ActiveRecord::Migration[8.1]
  def change
    create_table :mcp_tokens do |t|
      t.string :machine, null: false
      t.string :digest, null: false
      t.string :scopes, null: false, default: ""
      t.datetime :expires_at, null: false
      t.datetime :revoked_at
      t.datetime :last_used_at

      t.timestamps
    end
    add_index :mcp_tokens, :digest, unique: true
  end
end
