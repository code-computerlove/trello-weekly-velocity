trello-weekly-velocity
======================

Calculates weekly velocity from trello boards

##Introduction

This gem contains a class that can be used for calculating Calculates weekly velocity from trello boards

##Installation

The package is installed on rubygems and can be installed using the following command

    gem install 'trello-weekly-velocity'

or adding the following to your Gemfile
    
    gem 'TrelloWeeklyVelocity'

##Example

    require 'TrelloWeeklyVelocity'

    trello_weekly_velocity = AgileTrello::TrelloWeeklyVelocity.new(
	    public_key: 'aPublickey',
	    access_token: 'anAccessToken'
    )

    MY_BOARD_ID = '5aJf2ZMz'

    weekly_velocity = trello_weekly_velocity.get(
	    board_id: MY_BOARD_ID,
	    end_list: 'Ready for Release'
    )

    puts weekly_velocity.amount
    
##Trello Gotchas
You can get the access_token key by going to this url in your browser:
https://trello.com/1/authorize?key=YOUR_PUBLIC_KEY&name=YOUR_APP_NAME&response_type=token&scope=read,write,account&expiration=never

Your board id is included in the board uri e.g. in the uri https://trello.com/b/Fwrt4xH5/myBoard the id is Fwrt4xH5
