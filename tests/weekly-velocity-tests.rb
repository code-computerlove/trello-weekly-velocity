require 'test/unit'
require 'rspec-expectations'
require 'securerandom'

require 'TrelloCredentials'

module AgileTrello
	class WeeklyVelocity
		def initialize(parameters = {})
			trello_credentials = TrelloCredentials.new(parameters[:public_key], '')
			parameters[:trello_factory].create(trello_credentials)
		end
	end
end

class WeeklyVelocityTests < Test::Unit::TestCase	
	include AgileTrello

	def test_user_connects_to_trello_with_public_key
		public_key = SecureRandom.uuid
		mockTrelloFactory = self
		WeeklyVelocity.new(trello_factory: mockTrelloFactory, public_key: public_key) 
		expect(@trello_credentials.public_key).to eql(public_key)
	end 

	# def test_user_connects_to_trello_with_access_token
	# 	access_token = SecureRandom.uuid
	# 	mockTrelloFactory = self
	# 	TrelloCycleTime.new(trello_factory: mockTrelloFactory, access_token: access_token) 
	# 	expect(@trello_credentials.access_token).to eql(access_token)
	# end 

	def create(trello_credentials)
		@trello_credentials = trello_credentials
		@created_trello
	end

	def get_board(board_id)
		@retrieved_board_id = board_id
	end
end

