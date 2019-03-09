module KrakenMobile
  module Operations
    def readSignal(channel, timeout)
      sleep(timeout)
    end

    def writeSignal(channel, content)
      puts "Sending signal CONTENT:#{content} to CHANNEL:#{channel}"
    end
  end
end
