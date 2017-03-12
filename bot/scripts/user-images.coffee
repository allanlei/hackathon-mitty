# Description:
#   Hook up to Google Cloud Vision for image recognition
#
# Dependencies:
#   "moment": "^0.5.11"
#
# Configuration:
#   GOOGLE_PROJECT_ID
#
# Author:
#   allanlei@helveticode.com


Vision = require '@google-cloud/vision'
request = require 'request'
fs = require "fs"
streamBuffers = require 'stream-buffers'

vision = Vision
  projectId: process.env.GOOGLE_PROJECT_ID

USERS =
  U1XSFE1TN: process.env.SLACK_USER_TOKEN_U1XSFE1TN or process.env.SLACK_USER_TOKEN_allanlei
  U4HL289N3: process.env.SLACK_USER_TOKEN_U4HL289N3 or process.env.SLACK_USER_TOKEN_heather


module.exports = (robot) ->
  robot.on "file_share", (event) ->
    request
      url: event.filename
      encoding: null
      headers:
        Authorization: "Bearer #{USERS[event.user.id]}"
    , (err, response, body) ->
      if err
        robot.emit "file_share.error", event
        robot.logger.error err
        return

      annotateImageReq =
        image:
          content: body
        features: [
          {type: "WEB_DETECTION", maxResults: 5}
          {type: "LANDMARK_DETECTION", maxResults: 1}
        ]
        # imageContext:
        #

      robot.logger.info "Sending for annotation..."
      vision.annotate annotateImageReq, (err, annotations, apiResponse) ->
        robot.logger.info err, annotations
        if err
          robot.emit "detect.error", err
          for image in err.errors
            for error in image.errors
              robot.logger.error error
          return

        place = annotations[0].landmarkAnnotations[0] or annotations[0].webDetection.webEntities[0]
        if place
          robot.emit "attraction.understood",
            user: event.user
            channel: event.channel
            # source: event.filename
            # binary: body
            # message: message
            attraction: place

  robot.on "attraction.understood", (event) ->
    # TODO: Add Place card instead of plain message and pin message then upvote for user
    robot.messageRoom event.channel,
      text: "So you want to go to *#{event.attraction.description}*? Let me take some notes..."
      # attachments: [
    #     {
    #       title: "#{event.attraction.description}"
    #       # image_url: "https://maps.googleapis.com/maps/api/staticmap?#{qs}"
    #       image_url: event.source
    #     }
      # ]

    # robot.logger.info "event", event.channel
    # attractions = robot.brain.get("#{event.channel}:attractions") or {}
    # attractions[event.attraction.description] = event.attraction
    # robot.brain.set "#{event.channel}:attractions", attractions

    setTimeout () ->
      robot.emit "where.updated", event
    , 1 * 1000

  robot.on "attraction.understood", (event) ->
    attractions = robot.brain.get("#{event.channel}:attractions") or {}
    attractions[event.attraction.description] = event.attraction
    robot.brain.set "#{event.channel}:attractions", attractions
    # robot.logger.info attractions

  robot.on 'attraction.added', (event) ->
    # robot.logger.info place
    # robot.brain.set ''
