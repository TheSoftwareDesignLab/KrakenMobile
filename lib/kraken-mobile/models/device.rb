module KrakenMobile
	module Models
		class Device

      #-------------------------------
      # Fields
      #-------------------------------
			attr_accessor :id
			attr_accessor :model
      attr_accessor :position
      attr_accessor :config

      #-------------------------------
      # Constructors
      #-------------------------------
			def initialize(id, model, position, config = {})
				@id = id
				@model = model
        @position = position
        @config = config
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
