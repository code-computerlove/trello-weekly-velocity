module AgileTrello
	ONE_DAY = 86400

	class CardsCompletedInLastSevenDaysFilter
		SEVEN_DAYS_AGO = Time.now - (ONE_DAY * 7)
		MOVE_INTO_LIST_ACTION = 'updateCard'

		def initialize(end_list)
			@end_list = end_list
		end

		def match(card)
			moved_into_end_list_action = card.actions.find do | action | 
				action.type == MOVE_INTO_LIST_ACTION && action.data['listAfter']['name'] == @end_list 
			end   
			moved_into_end_list_action.date > SEVEN_DAYS_AGO
		end
	end
end