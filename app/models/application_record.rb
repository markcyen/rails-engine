class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  DATA_LIMIT = 20
end
