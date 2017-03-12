# Description:
#   Hook up to Google Cloud Vision
#
# Dependencies:
#   "request": "^0.5.11"
#
# Configuration:
#   GOOGLE_PROJECT_ID
#
# Author:
#   allanlei@helveticode.com


request = require 'request'

config =
  BOOKING_API_KEY: process.env.BOOKING_API_KEY


# module.exports = (robot) ->
#   request
#     url: "https://distribution-xml.booking.com/json/bookings.getBlockAvailability"
#     qs:
#       arrival_date: "2017-06-09"
#       departure_date: "2017-06-10"
#       hotel_ids: 10179
#     auth:
#       user: config.BOOKING_API_KEY.split(":")[0]
#       pass: config.BOOKING_API_KEY.split(":")[1]
#   , (err, response, body) ->
#     if err
#       return robot.logger.error err
#
#     data = JSON.parse body
#     robot.logger.info data
