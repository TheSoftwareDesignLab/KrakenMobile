module KrakenMobile
	module Models
		class Device

      #-------------------------------
      # Fields
      #-------------------------------
			attr_accessor :id
			attr_accessor :model
      attr_accessor :position

      #-------------------------------
      # Constructors
      #-------------------------------
			def initialize(id, model, position)
				@id = id
				@model = model
        @position = position
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
