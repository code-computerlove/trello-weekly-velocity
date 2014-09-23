module AgileTrello
	class CompletedCard
		attr_reader :complexity

		COMPLEXITY_REGEX = /\(\d*\)/

		def initialize(name)
			@complexity = (name.match(COMPLEXITY_REGEX).to_s.delete! '()').to_i
		end
	end
end