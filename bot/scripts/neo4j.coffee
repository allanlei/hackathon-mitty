# Description:
#   Hook data into neo4j to prepare better results
#
# Dependencies:
#   "moment": "^0.5.11"
#
# Configuration:
#   GOOGLE_PROJECT_ID
#
# Author:
#   allanlei@helveticode.com


neo4j = require('neo4j-driver').v1

module.exports = (robot) ->
  robot.neo4j = neo4j.driver "bolt://127.0.0.1:7687", neo4j.auth.basic("neo4j", "neo4j")

  # session = robot.neo4j.session()
  # session.run "CREATE (a:Person {name: {name}, title: {title}})", {name: "Arthur", title: "King"}, (err, result) ->
  #   session.close()
