require 'test/unit'
require 'rspec-expectations'
require 'securerandom'

require 'TrelloCredentials'
require_relative '../lib/CompletedCard'
require_relative '../lib/VelocityCalculator'
require_relative '../lib/CompletedCardRepository'

module AgileTrello
	ONE_DAY = 86400

	class TrelloWeeklyVelocity
		def initialize(parameters = {})
			trello_credentials = TrelloCredentials.new(parameters[:public_key], parameters[:access_token])
			trello_factory = parameters[:trello_factory].nil? ? TrelloFactory.new : parameters[:trello_factory]
			trello = trello_factory.create(trello_credentials)
			filter = CardsCompletedInLastSevenDaysFilter.new
			last_seven_days_cards = FilteredCardRepostitory.new(trello, filter)
			@completed_cards = CompletedCardRepository.new(last_seven_days_cards)
		end

		def get(parameters = {})
			velocity_calculator = VelocityCalculator.new
			@completed_cards
				.find(parameters[:board_id])
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

	class FilteredCardRepostitory 
		def initialize(trello, filter)
			@trello = trello
			@filter = filter
		end

		def find(board_id)
			board = @trello.get_board(board_id)
			return [] if board.lists.count === 0 
			return board.lists[0].cards.find_all {|card| @filter.match(card)} 
		end
	end

	class CardsCompletedInLastSevenDaysFilter
		SEVEN_DAYS_AGO = Time.now - (ONE_DAY * 7)

		def initialize()
		end

		def match(card)
			card.actions[0].date > SEVEN_DAYS_AGO
		end
	end
end

class WeeklyVelocityTests < Test::Unit::TestCase	
	include AgileTrello

	def test_user_connects_to_trello_with_public_key
		public_key = SecureRandom.uuid
		mockTrelloFactory = self
		TrelloWeeklyVelocity.new(trello_factory: mockTrelloFactory, public_key: public_key) 
		expect(@trello_credentials.public_key).to eql(public_key)
	end 

	def test_user_connects_to_trello_with_access_token
		access_token = SecureRandom.uuid
		mockTrelloFactory = self
		TrelloWeeklyVelocity.new(trello_factory: mockTrelloFactory, access_token: access_token) 
		expect(@trello_credentials.access_token).to eql(access_token)
	end 

	def test_zero_returned_when_no_lists_on_board
		board_id = SecureRandom.uuid
		board_with_no_lists = FakeBoard.new
		@created_trello = FakeTrello.new(board_id: board_id, board: board_with_no_lists)
		mockTrelloFactory = self
		weekly_velocity = TrelloWeeklyVelocity.new(trello_factory: mockTrelloFactory)
		weekly_velocity.get(board_id: board_id).amount.should eql(0)
	end

	def test_zero_returned_when_board_has_lists_but_no_cards
		board_id = SecureRandom.uuid
		board_with_no_cards = FakeBoard.new
		board_with_no_cards.add(FakeList.new('a list'))
		@created_trello = FakeTrello.new(board_id: board_id, board: board_with_no_cards)
		mockTrelloFactory = self
		weekly_velocity = TrelloWeeklyVelocity.new(trello_factory: mockTrelloFactory)
		weekly_velocity.get(board_id: board_id, end_list: '').amount.should eql(0)
	end

	def test_card_complexity_returned_when_card_entered_end_list_one_day_ago
		board_id = SecureRandom.uuid
		mockTrelloFactory = self
		end_list_name = "End List#{SecureRandom.random_number(100)}"
		card_complexity = SecureRandom.random_number(13)
		completed_one_day_ago_card = FakeCardBuilder.create
			.moved_to(end_list_name).days_ago(1)
			.complexity(card_complexity)
			.build
		list_with_one_card = FakeList.new(end_list_name)
		list_with_one_card.add(completed_one_day_ago_card)
		board_with_one_list = FakeBoard.new
		board_with_one_list.add(list_with_one_card)
		@created_trello = FakeTrello.new(board_id: board_id, board: board_with_one_list)
		weekly_velocity = TrelloWeeklyVelocity.new(trello_factory: mockTrelloFactory)
		velocity = weekly_velocity.get(board_id: board_id, end_list: end_list_name);
		velocity.amount.should eql(card_complexity)
	end

	def test_sum_of_card_complexities_returned_when_two_cards_entered_end_list_one_day_ago
		board_id = SecureRandom.uuid
		mockTrelloFactory = self
		end_list_name = "End List#{SecureRandom.random_number(100)}"
		card_complexity = SecureRandom.random_number(13)
		completed_one_day_ago_card = FakeCardBuilder.create
			.moved_to(end_list_name).days_ago(1)
			.complexity(card_complexity)
			.build
		list_with_two_card = FakeList.new(end_list_name)
		list_with_two_card.add(completed_one_day_ago_card)
		list_with_two_card.add(completed_one_day_ago_card)
		board_with_one_list = FakeBoard.new
		board_with_one_list.add(list_with_two_card)
		@created_trello = FakeTrello.new(board_id: board_id, board: board_with_one_list)
		weekly_velocity = TrelloWeeklyVelocity.new(trello_factory: mockTrelloFactory)
		velocity = weekly_velocity.get(board_id: board_id, end_list: end_list_name);
		velocity.amount.should eql(card_complexity * 2)
	end

	def test_sum_only_includes_card_card_complexity_of_card_that_entered_end_list_in_last_seven_days
		board_id = SecureRandom.uuid
		mockTrelloFactory = self
		end_list_name = "End List#{SecureRandom.random_number(100)}"
		card_complexity = SecureRandom.random_number(13)
		completed_one_day_ago_card = FakeCardBuilder.create
			.moved_to(end_list_name).days_ago(1)
			.complexity(card_complexity)
			.build
		completed_seven_days_ago_card = FakeCardBuilder.create
			.moved_to(end_list_name).days_ago(8)
			.complexity(card_complexity)
			.build
		list_with_two_card = FakeList.new(end_list_name)
		list_with_two_card.add(completed_one_day_ago_card)
		list_with_two_card.add(completed_seven_days_ago_card)
		board_with_one_list = FakeBoard.new
		board_with_one_list.add(list_with_two_card)
		@created_trello = FakeTrello.new(board_id: board_id, board: board_with_one_list)
		weekly_velocity = TrelloWeeklyVelocity.new(trello_factory: mockTrelloFactory)
		velocity = weekly_velocity.get(board_id: board_id, end_list: end_list_name);
		velocity.amount.should eql(card_complexity)
	end

	def create(trello_credentials)
		@trello_credentials = trello_credentials
		@created_trello
	end

	def get_board(board_id)
		@retrieved_board_id = board_id
	end
end

class FakeTrello
	def initialize(parameters)
		@boards = {
			parameters[:board_id] => parameters[:board]
		}
	end

	def get_board(board_id)
		@boards[board_id]
	end
end

class FakeBoard
	attr_reader :lists 

	def initialize 
		@lists = []
	end

	def add(list)
		@lists.push(list)
	end
end

class FakeList
	attr_reader :name, :cards

	def initialize(name)
		@name = name
		@cards = []
	end

	def add(card)
		@cards.push(card)
	end
end

class FakeCardBuilder
	ONE_DAY = 86400

	def initialize
		@fake_card = FakeCard.new 
	end

	def self.create 
		FakeCardBuilder.new
	end

	def moved_to(list_name)
		return MovementBuilder.new(self, @fake_card, list_name)
	end

	def complexity(complexity)
		@fake_card.add_complexity(complexity)
		return self
	end

	def build
		@fake_card
	end

	class MovementBuilder
		def initialize(fake_card_builder, fake_card, list_name)
			@fake_card_builder = fake_card_builder
			@fake_card = fake_card
			@list_name = list_name
			@todays_date = Time.now
		end

		def today
			@fake_card.add_movement(list_name: @list_name, date: @todays_date)
			return @fake_card_builder
		end

		def days_ago(days)
			date = @todays_date - (ONE_DAY * days)
			@fake_card.add_movement(list_name: @list_name, date: date)
			return @fake_card_builder
		end
	end
end

class FakeCard
	attr_reader :actions, :name

	def initialize
		@actions = []
	end

	def add_complexity(complexity)
		@name = "{AClient} (#{complexity}) blah blah blah"
	end

	def add_movement(parameters)
		action = FakeMovementAction.new(parameters)
		@actions.push(action)
	end
end

class FakeMovementAction 
	attr_reader :type, :data, :date

	def initialize(parameters)
		@type = 'updateCard'
		@date = parameters[:date]
		@data = {
			'listAfter' => {
				'name' => parameters[:list_name]
			}
		}
	end
end
