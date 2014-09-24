module AgileTrello
	class TrelloBoard
		def initialize(board)
			@board = board
		end

		def get_cards_after_list(end_list_name)
			found_end = false
			cards = []
			@board.lists.each do | list |
				found_end = true if !found_end && (list.name.include? end_list_name)
				if (found_end)
					list.cards.each do | card |
						cards.push(card)
					end
				end
			end
			return cards 
		end
	end
end