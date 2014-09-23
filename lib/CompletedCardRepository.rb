module AgileTrello
	class CompletedCardRepository
		def initialize(card_repository)
			@card_repository = card_repository
		end

		def find(parameters)
			cards = @card_repository.find(parameters)
			return cards.map { | card | CompletedCard.new(card.name) }
		end
	end
end