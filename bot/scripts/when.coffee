# Description:
#   Handles start and leave time questions
#
# Dependencies:
#   "moment": "^2.17.1",
#
# Configuration:
#   GOOGLE_PROJECT_ID
#
# Author:
#   allanlei@helveticode.com


moment = require "moment"

module.exports = (robot) ->
  robot.hear /(\w+) (\d{1,2})-(\d+)/i, (res) ->
    [month, start_date, end_date] = res.match.slice 1
    start = moment("#{month}#{start_date}", "MMMDD")
    end = moment("#{month}#{end_date}", "MMMDD")

    robot.emit "when.updated",
      user:
        id: res.envelope.user.id
        name: res.envelope.user.name
      channel: res.envelope.message.room
      start: start
      end: end

  robot.hear /I want to go (\w+) (\d{1,2}) for (\d+) days/i, (res) ->
    [month, date, days] = res.match.slice 1
    start = moment("#{month}#{date}", "MMMDD")
    end = moment(start).add days, "days"

    robot.emit "when.updated",
      user:
        id: res.envelope.user.id
        name: res.envelope.user.name
      channel: res.envelope.message.room
      start: start
      end: end

  robot.hear /I want to leave (\w+) (\d{1,2}) and come back (\w+) (\d{1,2})/i, (res) ->
    [start_month, start_date, end_month, end_date] = res.match.slice 1
    start = moment("#{start_month}#{start_date}", "MMMDD")
    end = moment("#{end_month}#{end_date}", "MMMDD")

    robot.emit "when.updated",
      user:
        id: res.envelope.user.id
        name: res.envelope.name
      channel: res.message.room
      start: start
      end: end

  robot.on "when.required", (event) ->
    robot.messageRoom event.channel, "When would you like to go?"

  robot.on "when.updated", (event) ->
    robot.messageRoom event.channel, "Ok <@#{event.user.id}|#{event.user.name}>. I'll find some suggestions between *#{event.start.format 'LL'}* and *#{event.end.format 'LL'}*"

  robot.on "when.updated", (event) ->
    robot.logger.info "when.updated", event
    robot.brain.set "#{event.channel}:when",
      start: event.start
      end: event.end
