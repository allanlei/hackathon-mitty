# Description:
#   Handle's trip budget
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
  robot.hear /Our budget is \$(\d+)/i, (res) ->
    [budget] = res.match.slice 1
    budget = Number(budget)
    robot.brain.set "#{res.envelope.room}:budget", budget

    robot.emit "budget.updated",
      user:
        id: res.envelope.user.id
        name: res.envelope.user.name
      channel: res.envelope.message.room
      budget: budget
