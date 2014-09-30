module AgileTrello
	class CardContainsComplexityFilter
		def initialize(next_filter)
			@next_filter = next_filter
		end

		def match(card)
			return false unless card.name.match(/\(\d*\)/)
			return @next_filter.match(card)
		end
	end
end