# Description:
#   Handle Help Options
#   also: internet speed checks and critical system status
#
# Commands:
#   hubot 
#   hubot 
#
# Author:
#   Bren Sapience <brendan.sapience@gmail.com>

utils = require './utils'

getReleaseNotes = (message) ->
  message += " *Mar 27 - 2018*: _Initial Release, search for objects per type and per folder_\n"

getHelpSearches = (message) -> 
  message += "\t*Object Searches*\n"
  message += "\t\t *Search for Objects*: _search for <SearchPattern>_ \n"
  message += "\t\t\t*Example*: say: \"_search for EXECUTE*_\" \n" 
  message += "\t\t *Search for Objects (with Type filter)*: _search <List of Types, Ex: JOBS,CONN,JOBP> for <SearchPattern>_ \n"
  message += "\t\t\t*Example*: say: \"_search JOBS,CONN,JOBP for EXECUTE*_\" \n" 
  message += "\t\t *Search for Objects (with Type and Location filters)*: _search <List of Types, Ex: JOBS,CONN,JOBP> for <SearchPattern> in <Location>_ \n"
  message += "\t\t\t*Example*: say: \"_search JOBS,CONN,JOBP for EXECUTE* in \\BELL_\" \n" 

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
    message += "\n\t *For All Users*:\n"
    message += "\t\t Object Searches (ask for \"*help me with searches*\")\n"
    message += "\t\t Get Release Notes (ask for \"*get release notes*\")\n"

    message += "\n\n\n\n"
    msg.reply message


  ####
  # Help Me with searches
  ####
  robot.hear /(?:a little|some|can you)*(?: )*help(?: )*(?:please|me|me please)* with (?:search|searches|lookup|lookups)/i, (msg) ->
    message = ""
    message = message + getHelpSearches(message)
    msg.reply message


  ####
  # Help Me EVERYTHING
  ####
  robot.hear /(?:a little|some|can you)*(?: )*help(?: )*(?:please|me|me please)* with (?:everything|all)/i, (msg) ->
    message = ""
    message = message + getHelpSearches(message)
    
    msg.reply message

  ####
  # Get Release Notes
  ####
  robot.hear /(?:get|show|show[ ]*me)(?: )*(?:the)*(?: )*(?:release notes|notes|rnotes|release|releases)/i, (msg) ->
    message = "\n"
    message = message + getReleaseNotes(message)
    msg.reply message
