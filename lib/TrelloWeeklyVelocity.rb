require 'TrelloCredentials'
require 'TrelloFactory'
require_relative '../lib/CompletedCard'
require_relative '../lib/VelocityCalculator'
require_relative '../lib/CompletedCardRepository'
require_relative '../lib/TrelloBoards'
require_relative '../lib/FilteredCardRepository'
require_relative '../lib/CardsCompletedInLastSevenDaysFilterFactory'

module AgileTrello
	class TrelloWeeklyVelocity
		def initialize(parameters = {})
			trello_credentials = TrelloCredentials.new(parameters[:public_key], parameters[:access_token])
			trello_factory = parameters[:trello_factory].nil? ? TrelloFactory.new : parameters[:trello_factory]
			trello = trello_factory.create(trello_credentials)
			trello_boards = TrelloBoards.new(trello)
			last_seven_days_cards = FilteredCardRepostitory.new(trello_boards)
			@completed_cards = CompletedCardRepository.new(last_seven_days_cards)
			@filter_factory = CardCompletedInLastSevenDaysFilterFactory.new(trello_boards)		
		end

		def get(parameters = {})
			filter = @filter_factory.create(parameters[:board_id], parameters[:end_list])
			velocity_calculator = VelocityCalculator.new
			@completed_cards
				.find(board_id: parameters[:board_id], end_list: parameters[:end_list], filter: filter)
				.each { | card | velocity_calculator.add(card.complexity) }	
			return WeeklyVelocity.new(velocity_calculator.total);
		end
	end

	class WeeklyVelocity 
		attr_reader :amount

		def initialize(amount)
			@amount = amount
		end
	end
end