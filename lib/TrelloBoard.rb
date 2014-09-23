module AgileTrello
	class TrelloBoard
		def initialize(board)
			@board = board
		end

		def get_cards_after_list(end_list_name)
			end_list = @board.lists.find{ | list | list.name == end_list_name}
			return end_list.cards unless end_list.nil?
			return []
		end
	end
end