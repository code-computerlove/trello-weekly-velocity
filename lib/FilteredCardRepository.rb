module AgileTrello
	class FilteredCardRepostitory 
		def initialize(trello_boards)
			@trello_boards = trello_boards
		end

		def find(parameters)
			filter = parameters[:filter]
			@trello_boards
				.get(parameters[:board_id])
				.get_cards_after_list(parameters[:end_list])
				.find_all {|card| filter.match(card)} 
		end
	end
end