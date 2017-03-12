# Description:
#   Get the status of the current submitted data to the trip
#
# Dependencies:
#   "moment": "^0.5.11"
#
# Configuration:
#   GOOGLE_MAPS_API_KEY
#
# Author:
#   allanlei@helveticode.com
querystring = require 'querystring'
request = require 'request'
async = require "async"
moment = require "moment"

config =
  GOOGLE_MAPS_API_KEY: process.env.GOOGLE_MAPS_API_KEY
  BOOKING_API_KEY: process.env.BOOKING_API_KEY


module.exports = (robot) ->
  robot.hear /Show me what you got so far/i, (res) ->
    who = robot.brain.get "#{res.envelope.room}:who" or [null]
    attractions = (robot.brain.get "#{res.envelope.room}:attractions" or [])
    destinations = (dest for dest of attractions)
    timerange = robot.brain.get "#{res.envelope.room}:when"
    start = moment timerange.start
    end = moment timerange.end

    res.send
      text: [
        "I can see that there are *#{who.length}* travellers leaving *#{start.format 'LL'}* and coming back *#{end.format 'LL'}*."
        # "You set a budget of $#{budget}"
        "You want to go to #{destinations.join(', ')}..."
      ].join("\n")
