# Description:
#   Handles starting and completing a booking
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
  robot.hear /suggest some plans+/i, (res) ->
    attractions = robot.brain.get "#{res.envelope.room}:attractions"
    attendees = robot.brain.get "#{res.envelope.room}:who"
    timerange = robot.brain.get "#{res.envelope.room}:when"
    start = moment timerange.start
    end = moment timerange.end
    locations = [(data for attraction, data of attractions when data and data.locations)[0].locations[0].latLng]

    robot.logger.info attendees
    robot.logger.info start, end
    robot.logger.info locations

    tasks = [
      (cb) ->
        request
          url: "https://distribution-xml.booking.com/json/getHotelAvailabilityV2"
          auth:
            user: config.BOOKING_API_KEY.split(":")[0]
            pass: config.BOOKING_API_KEY.split(":")[1]
          qs:
            longitude: locations[0].longitude.toString()
            latitude: locations[0].latitude.toString()
            checkin: start.format "YYYY-MM-DD"
            checkout: end.format "YYYY-MM-DD"
            order_by: "review_score"
            order_by: "popularity"
            order_dir: "desc"
            max_price: 150
            output: ["room_details", "hotel_details", "room_amenities", "hotel_amenities"].join(",")
            min_review_score: 7
            rows: 10
            room1: ("A" for attendee in attendees).join(",")
            radius: 25
        , (err, response, body) ->
          if err
            robot.logger.error err
            return cb err, []
          data = JSON.parse body
          robot.logger.info data

          cb null,
            hotels: data.hotels
    ]

    async.parallel tasks, (err, days) ->
      qs = querystring.stringify
        key: config.GOOGLE_MAPS_API_KEY
        center: [
          (data for attraction, data of attractions when data and data.locations)[0].locations[0].latLng.latitude,
          (data for attraction, data of attractions when data and data.locations)[0].locations[0].latLng.longitude,
        ].join(",")
        zoom: 10
        size: "640x400"
        maptype: "roadmap"
        markers: ("color:green|label:A|#{data.locations[0].latLng.latitude},#{data.locations[0].latLng.longitude}" for attraction, data of attractions when data and data.locations)

      hotel = days[0].hotels[0]
      hotel2 = days[0].hotels[1]

      res.send
        # text: [
        #   "*Day 1 - Osaka, Japan*"
        #   "Hotel Recommendations"
        # ].join("\n")
        attachments: [
          {
            title: "Plan #1"
            title_link: "https://www.booking.com/"
            image_url: "https://maps.googleapis.com/maps/api/staticmap?#{qs}"
            color: "#36a64f"
          }
          {
            title: "Day 1 - Osaka, Japan"
            text: "Hotel Recommendations"
            color: "#36a64f"
          }
          {
            title: "#{hotel.hotel_name}"
            title_link: "https://www.booking.com/"
            thumb_url: "http://aff.bstatic.com/images/hotel/max300_watermarked_standard/eb1/eb18e1e4281e2f75dd3b8a55050fe85e249918ae.jpg"
            text: [
              "#{hotel.address}"
              (":star:" for star in [1..hotel.stars]).join("")
              "#{hotel.review_score_word} #{hotel.review_score}"
            ].join("  ")
            fields: for room in hotel.group_rooms
              title: "#{room.room_name}", value: "#{hotel.hotel_currency_code} #{room.price}", short: true
            color: "#36a64f"
            footer: "Check In: #{hotel.checkin_time.from}. Check Out: 11:00"
          }
          # {
          #   title: "#{hotel2.hotel_name}"
          #   title_link: "https://www.booking.com/"
          #   thumb_url: "http://aff.bstatic.com/images/hotel/max500_watermarked_standard/1c7/1c70889b37696dede0170a506de1f06a3cce2845.jpg"
          #   text: [
          #     "#{hotel2.address}"
          #     (":star:" for star in [1..hotel2.stars]).join("")
          #     "#{hotel2.review_score_word} #{hotel2.review_score}"
          #   ].join("  ")
          #   fields: for room in hotel2.group_rooms
          #     title: "#{room.room_name}", value: "#{hotel2.hotel_currency_code} #{room.price}", short: true
          #   color: "#36a64f"
          #   footer: "Check In: #{hotel2.checkin_time.from}. Check Out: 11:00"
          # }
          # {
          #   title: "View more"
          #   title_link: "https://api.slack.com/"
          # }
          {
            # title: "View more"
            # title_link: "https://api.slack.com/"
            text: "View more recommended hotels"
            footer: "Type next suggest more"
          }
        ]

    # res.send
    #   attachments: [
    #     {
    #       title: "Plan #1"
    #       image_url: "https://maps.googleapis.com/maps/api/staticmap?#{qs}"
    #       color: "#36a64f"
    #     }
    #   ]
    #     {
    #       title: "Day 1 to Day 3"
    #       title_link: "https://api.slack.com/"
    #       author_name: "Holiday Inn"
    #       # author_link: "http://flickr.com/bobby/"
    #       # author_icon: "http://flickr.com/icons/bobby.jpg"
    #       # "text": "Optional text that appears within the attachment",
    #       fields: [
    #         {title: "asdasdasd", value: "sdfsdfsdf", short: false}
    #       ]
    #       text: "sdfsdfsdf"
    #       color: "#36a64f"
    #       footer: "Check In: 3pm. Check Out: 12pm"
    #       # ts: 1234567890
    #     }
    #     {
    #       title: "Day 4 to Day 8 :star:"
    #       title_link: "https://api.slack.com/"
    #       author_name: "Sheraton :star:"
    #       # author_link: "http://flickr.com/bobby/"
    #       # author_icon: "http://flickr.com/icons/bobby.jpg"
    #       color: "#36a64f"
    #       # "text": "Optional text that appears within the attachment",
    #       fields: [
    #         {title: "asdasdasd", value: "sdfsdfsdf", short: false}
    #         {title: "Stars", value: ":star::star::star::star:", short: true}
    #       ]
    #       footer: "Check In: 3pm. Check Out: 12pm"
    #       # ts: 1234567890
    #     }
    #     {
    #       title: "Day 9 to Day 14"
    #       title_link: "https://api.slack.com/"
    #       author_name: "W Hotel"
    #       # author_link: "http://flickr.com/bobby/"
    #       # author_icon: "http://flickr.com/icons/bobby.jpg"
    #       color: "#36a64f"
    #       # "text": "Optional text that appears within the attachment",
    #       fields: [
    #         {title: "asdasdasd", value: "sdfsdfsdf", short: false}
    #       ]
    #       footer: "Check In: 3pm.\tCheck Out: 12pm"
    #       # ts: 1234567890
    #     }
