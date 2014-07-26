class {{EntityName}} < ActiveRecord::Base
  <<< start one_to_many >>>
  has_many {{entity_names}}
  <<< end one_to_many >>>
end