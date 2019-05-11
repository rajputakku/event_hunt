class MasterRole < ActiveRecord::Base
	has_many :users
end
