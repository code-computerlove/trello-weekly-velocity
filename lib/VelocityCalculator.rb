module AgileTrello
	class VelocityCalculator
		def initialize
			@total = 0
		end

		def add(complexity)
			@total += complexity
		end

		def total
			@total
		end
	end
end