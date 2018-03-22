# Description:
#   Handle Help Options
#  
#
# Commands:
#   hubot 
#   hubot 
#
# Author:
#   Bren Sapience <brendan.sapience@gmail.com>

utils = require './utils'

getReleaseNotes = (message) ->
  message += " *Jan 24 - 2018*: _First Release._\n"


module.exports = (robot) ->

  robot.hear /.*(?:hi|hello|yo|hey|howdy|howdi|salut|[s]+up)$/i, (msg) ->

    hellos = ['Hi', 'Yo', 'Whats up', 'hey', 'salut', 'hello']
    greeting = msg.random hellos
    username = msg.message.user.name
    msg.send "#{greeting} #{username}, if you need help at any moment just type in 'help me'"
 
  ####
  # Help Me
  ####
  robot.hear /(?:help$|help[ ]*me$)/i, (msg) ->
    message = "Hey, #{msg.message.user.name},"
    message += "\nHere is all the topics i can help you with.. feel free to ask about them:\n"
    message += "\n\t *For Most Users*:\n"

    message += "\n\n\n\n"
    msg.reply message

  ####
  # Get Release Notes
  ####
  robot.hear /(?:get|show|show[ ]*me)(?: )*(?:the)*(?: )*(?:release notes|notes|rnotes|release|releases)/i, (msg) ->
    message = "\n"
    message = message + getReleaseNotes(message)
    msg.reply message
