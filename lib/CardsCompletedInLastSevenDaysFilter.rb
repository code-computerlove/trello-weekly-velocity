module AgileTrello
	ONE_DAY = 86400

	class CardsCompletedInLastSevenDaysFilter
		SEVEN_DAYS_AGO = Time.now - (ONE_DAY * 7)
		MOVE_INTO_LIST_ACTION = 'updateCard'

		def initialize(end_list, lists_after_end_list)
			@end_list = end_list
			@lists_after_end_list = lists_after_end_list
		end

		def match(card)
			moved_into_end_list_action = find_movement_action(@end_list, card) 
			count = 0
			until (moved_into_end_list_action || count == @lists_after_end_list.length) do
				list_name = @lists_after_end_list[count]
				moved_into_end_list_action = find_movement_action(list_name, card)
				count = count+1
			end
			moved_into_end_list_action && moved_into_end_list_action.date > SEVEN_DAYS_AGO
		end

		private 
		def find_movement_action(list_name, card)
			card.actions.find do | action | 
				action.type == MOVE_INTO_LIST_ACTION && action.data && action.data['listAfter'] && action.data['listAfter']['name'] == list_name 
			end
		end
	end
end