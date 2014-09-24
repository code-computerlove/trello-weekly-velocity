module AgileTrello
	class TrelloBoard
		def initialize(board)
			@board = board
		end

		def get_cards_after_list(end_list_name)
			found_end = false
			cards = []
			@board.lists.each do | list |
				found_end = true if !found_end && (list.name == end_list_name)
				cards = cards + list.cards
			end
			return cards 
		end
	end
end