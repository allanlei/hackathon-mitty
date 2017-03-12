# Description:
#   Dev stuff
#
# Dependencies:
#   "moment": "^0.5.11"
#
# Configuration:
#   GOOGLE_MAPS_API_KEY
#
# Author:
#   allanlei@helveticode.com


module.exports = (robot) ->
  # robot.on "file_share", (event) ->
  #   robot.logger.info event

  # robot.on "running", (event) ->
  #   robot.logger.info "SDFJSUDFHUSIHDFUIHSUIDHFHSUIHDFHSUDFUI"

  robot.respond /info/i, (res) ->
    who = robot.brain.get "#{res.envelope.room}:who"
    _when = robot.brain.get "#{res.envelope.room}:when"
    attractions = robot.brain.get "#{res.envelope.room}:attractions"

    res.send "```#{JSON.stringify who, null, 4}```"
    res.send "```#{JSON.stringify _when, null, 4}```"
    res.send "```#{JSON.stringify attractions, null, 4}```"

  # setTimeout () ->
    # robot.messageRoom "G4GTCDA5R",
    #   title: "Welcome"
    #   text: "sdfsdfsdf"
    #   attachments: [
    #     {
    #       # title: "sdfsdfsjdf"
    #       # image_url: "https://maps.googleapis.com/maps/api/staticmap?center=Brooklyn+Bridge,New+York,NY&zoom=13&size=600x300&maptype=roadmap&markers=color:blue%7Clabel:S%7C40.702147,-74.015794&markers=color:green%7Clabel:G%7C40.711614,-74.012318&markers=color:red%7Clabel:C%7C40.718217,-73.998284&key=#{config.GOOGLE_MAPS_API_KEY}"
    #       # image_url: "https://maps.googleapis.com/maps/api/staticmap?#{qs}"
    #       image_url: "https://www.dropbox.com/s/csw1ak9pyg5eewz/mitty-welcome.png?dl=1"
    #     }
    #   ]

  #   robot.emit "file_share",
  #     user:
  #       id: "U1XSFE1TN"
  #       name: "allanlei"
  #     channel: "G4GTCDA5R"
  #     filename: "https://files.slack.com/files-pri/T1XSJ9BCY-F4HL89W8P/download/1489211983383152288292.jpg"
  #     message: {}
  # , 0.5 * 1000
