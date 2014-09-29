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

		def get_list_names_after(end_list_name)
			list_names = @board.lists.map { | list | list.name }
			end_list_position = list_names.index{ |list_name | list_name.include? end_list_name  }
			return [] unless end_list_position
			return list_names.slice(end_list_position+1, list_names.length)
		end
	end
end