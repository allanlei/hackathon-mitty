# Description:
#   Slack events dispatcher
#
# Dependencies:
#   "moment": "^0.5.11"
#
# Configuration:
#   GOOGLE_PROJECT_ID
#
# Author:
#   allanlei@helveticode.com


module.exports = (robot) ->
  # REF: https://api.slack.com/events
  robot.adapter.client.on 'raw_message', (message) ->
    message = JSON.parse message
    # robot.logger.info message

    switch ("#{message.type}.#{message.subtype}")
      when "message.file_share"
        robot.emit message.subtype,
          user:
            id: message.user
            name: (message.username and message.username.slice(1, -1).split("|")[1]) or (message.user_profile and message.user_profile.name)
          channel: message.channel
          filename: message.file.url_private
          message: message
      when "pong.undefined" then
      when "reconnect_url.undefined" then
      when "presence_change.undefined" then
      else
        robot.logger.info "Slack Event: ", message

  # robot.react (res) ->
  #   robot.logger.debug res.message.type, res.message.reaction
  #   if res.message.type == "added"
  #     robot.adapter.client.web.reactions.add(res.message.reaction, {channel: res.message.item.channel, timestamp: res.message.item.ts})
