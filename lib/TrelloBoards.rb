require_relative './TrelloBoard'

module AgileTrello
	class TrelloBoards
		def initialize(trello)
			@trello = trello
		end

		def get(board_id)
			board = @trello.get_board(board_id)
			return TrelloBoard.new(board)
		end
	end
end