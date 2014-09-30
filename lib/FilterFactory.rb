require_relative './CardsCompletedInLastSevenDaysFilter'
require_relative './CardContainsComplexityFilter'

module AgileTrello
	class FilterFactory 
		def initialize(trello_boards)
			@trello_boards = trello_boards
		end

		def create(board_id, end_list_name)
			trello_board = @trello_boards.get(board_id)
			lists_after = trello_board.get_list_names_after(end_list_name)
			seven_day_filter = CardsCompletedInLastSevenDaysFilter.new(end_list_name, lists_after)
			CardContainsComplexityFilter.new(seven_day_filter)
		end
	end
end