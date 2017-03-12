# Description:
#   Handles destination questions
#
# Configuration:
#   GOOGLE_PROJECT_ID
#
# Author:
#   allanlei@helveticode.com


moment = require "moment"

module.exports = (robot) ->
  robot.hear /(.*), \d+ people, \w+ \w+-\w+/i, (res) ->
    [destination] = res.match.slice 1
    setTimeout () ->
      res.send
        text: [
          "Sounds great! You can send me images, keywords, or locations you would like to go to so we can start planning!"
          "_Tips: The more information you provide the better the plan will be_"
        ].join("\n")
    , 2 * 1000

  robot.hear /I want to go to (.*)/i, (res) ->
    [destination] = res.match.slice 1
    attraction =
      description: destination
      locations: [
        {latitude: 123123, longitude: 12312312}
      ]

    attractions = robot.brain.get("#{res.message.room}:attractions") or {}
    attractions[attraction.description] = attraction
    robot.brain.set "#{res.message.room}:attractions", attractions

    robot.emit "where.updated",
      user:
        id: res.envelope.user.id
        name: res.envelope.user.name
      channel: res.message.room
      attraction: attraction

  robot.on "where.required", (event) ->
    robot.messageRoom event.channel, "Where would you like to go?"

  robot.on "where.updated", (event) ->
    robot.messageRoom event.channel,
      title: "*#{event.attraction.description}*"
      text: "Ok <@#{event.user.id}|#{event.user.name}>. I added it to your destinations"

  robot.on "where.updated", (event) ->
    robot.logger.info "where.updated", event
    robot.brain.set "#{event.channel}:where", event.attendees
