# frozen_string_literal: true

class BackfillPasswordlessSessionIdentifiers < ActiveRecord::Migration[8.1]
  class PasswordlessSession < ActiveRecord::Base
    self.table_name = "passwordless_sessions"
  end

  def up
    PasswordlessSession.where(identifier: nil).find_each do |session|
      session.update_columns(identifier: SecureRandom.uuid)
    end

    change_column_null(:passwordless_sessions, :identifier, false)
  end

  def down
    change_column_null(:passwordless_sessions, :identifier, true)
  end
end
