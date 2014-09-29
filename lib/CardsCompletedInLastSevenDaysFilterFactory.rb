require_relative './CardsCompletedInLastSevenDaysFilter'

module AgileTrello
	class CardCompletedInLastSevenDaysFilterFactory 
		def initialize(trello_boards)
			@trello_boards = trello_boards
		end

		def create(board_id, end_list_name)
			trello_board = @trello_boards.get(board_id)
			lists_after = trello_board.get_list_names_after(end_list_name)
			CardsCompletedInLastSevenDaysFilter.new(end_list_name, lists_after)
		end
	end
end