# Description:
#   Welcome message
#
# Dependencies:
#   "moment": "^0.5.11"
#
# Configuration:
#   None
#
# Author:
#   allanlei@helveticode.com


module.exports = (robot) ->
  robot.enter (res) ->
    res.send
      attachments: [
        {
          text: " "
          image_url: "https://www.dropbox.com/s/csw1ak9pyg5eewz/mitty-welcome.png?dl=1"
        }
        {
          text: [
            "Let's get started by telling me about your destination, time of travel and number of people."
            "_eg. Boston, 4 people, June 15-20_"
            ""
            "*Tip*: If you are travelling with friends, you may add them by typing `/invite_people their@email.com` in the message box"
          ].join("\n")
          mrkdwn_in: ["text"]
        }
      ]
