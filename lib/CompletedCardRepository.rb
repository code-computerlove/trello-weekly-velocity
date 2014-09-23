module AgileTrello
	class CompletedCardRepository
		def initialize(card_repository)
			@card_repository = card_repository
		end

		def find(board_id)
			cards = @card_repository.find(board_id)
			return cards.map { | card | CompletedCard.new(card.name) }
		end
	end
end