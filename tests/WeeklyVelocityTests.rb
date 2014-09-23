require 'test/unit'
require 'rspec-expectations'
require 'securerandom'

require 'TrelloCredentials'

module AgileTrello
	class TrelloWeeklyVelocity
		def initialize(parameters = {})
			trello_credentials = TrelloCredentials.new(parameters[:public_key], parameters[:access_token])
			parameters[:trello_factory].create(trello_credentials)
		end

		def get(parameters = {})
			return WeeklyVelocity.new(0)
		end
	end

	class WeeklyVelocity 
		attr_reader :amount

		def initialize(amount)
			@amount = amount
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

