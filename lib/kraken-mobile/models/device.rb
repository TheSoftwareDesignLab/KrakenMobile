module KrakenMobile
	module Models
		class Device
      
      #-------------------------------
      # Fields
      #-------------------------------
			attr_accessor :id
			attr_accessor :model

      #-------------------------------
      # Constructors
      #-------------------------------
			def initialize(id, model)
				@id = id
				@model = model
			end

      #-------------------------------
      # Helpers
      #-------------------------------
			def screenshot_prefix
				@id.gsub('.', '_').gsub(/:(.*)/, '').to_s + '_'
			end

		end
	end
end
