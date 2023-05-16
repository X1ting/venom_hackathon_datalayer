class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
  connects_to database: { writing: :postgresql, reading: :postgresql }
end
