class Old < ApplicationRecord
  self.abstract_class = true

  connects_to database: {writing: :old, reading: :old}
end
