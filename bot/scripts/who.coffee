# Description:
#   Handles travel party questions
#
# Configuration:
#   GOOGLE_PROJECT_ID
#
# Author:
#   allanlei@helveticode.com


moment = require "moment"

module.exports = (robot) ->
  robot.hear /(\d+) [people|person|persons]+/i, (res) ->
    [attendees] = res.match.slice 1

    robot.emit "who.updated",
      user:
        id: res.envelope.user.id
        name: res.envelope.user.name
      channel: res.envelope.message.room
      attendees: (null for num in [1..attendees])


  robot.on "who.required", (event) ->
    robot.messageRoom event.channel, "How many people are going?"

  robot.on "who.updated", (event) ->
    robot.messageRoom event.channel, "Ok <@#{event.user.id}|#{event.user.name}>. I'll make plans for *#{event.attendees.length} people*"

  robot.on "who.updated", (event) ->
    robot.logger.info "who.updated", event
    robot.brain.set "#{event.channel}:who", event.attendees
