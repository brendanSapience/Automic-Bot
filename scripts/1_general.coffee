# Description:
#   Handle Help Options
#
# Commands:
#   hubot 
#
# Author:
#   Bren Sapience <brendan.sapience@gmail.com>

utils = require './utils'

AE_HOST = process.env.AUTOMIC_HOSTNAME_OR_IP
REST_PORT = process.env.AUTOMIC_AE_REST_PORT
REST_PATH = process.env.AUTOMIC_AE_REST_PATH
CLIENT = process.env.AUTOMIC_AE_CLIENT

getReleaseNotes = (message) ->
  message += " *Mar 29 - 2018*: _Added executions handling_\n"
  message += " *Mar 27 - 2018*: _Initial Release, search for objects per type and per folder_\n"

getHelpExecutions = (message) -> 
  message += "\t*Object Executions*\n"
  message += "\t\t *Run an Object*: _run|start|execute <Object Name>_ \n"
  message += "\t\t\t*Example*: say: \"_run AUTOMIC.JOBP.TEST.1_\" \n" 
  message += "\t\t *Rerun an Object*: _rerun|restart|reexecute <RunID>_ \n"
  message += "\t\t\t*Example*: say: \"_rerun 1234567*_\" \n" 
  message += "\t\t *Cancel a Run*: _cancel|stop|abort <RunID>_ \n"
  message += "\t\t\t*Example*: say: \"_cancel 1234567_\" \n" 
  message += "\t\t *Get Info & Status on a Run*: _get|check run <RunID>_ \n"
  message += "\t\t\t*Example*: say: \"_get run 1234567_\" \n" 
  message += "\t\t *Get Info & Status on all Children of a Run*: _get|check children of run <RunID>_ \n"
  message += "\t\t\t*Example*: say: \"_get children of run 1234567 1234567_\" \n" 

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
    Resp = "#{greeting} #{username}, if you need help at any moment just type in 'help me'"
    Resp = Resp + "\n Current System: \n\t Client: *#{CLIENT}* \n\t Host: *#{AE_HOST}* \n\t Rest Port: *#{REST_PORT}* \n\t Rest Path: *#{REST_PATH}*"
    msg.send Resp
  ####
  # Help Me
  ####
  robot.hear /(?:help$|help[ ]*me$)/i, (msg) ->
    message = "Hey, #{msg.message.user.name},"
    message += "\nHere is all the topics i can help you with.. feel free to ask about them:\n"
    message += "\n\t *For All Users*:\n"
    message += "\t\t Object Searches (ask for \"*help me with searches*\")\n"
    message += "\t\t Object Executions (ask for \"*help me with runs*\")\n"
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
  # Help Me with executions
  ####
  robot.hear /(?:a little|some|can you)*(?: )*help(?: )*(?:please|me|me please)* with (?:execution|executions|run|runs|runid|runids)/i, (msg) ->
    message = ""
    message = message + getHelpExecutions(message)
    msg.reply message


  ####
  # Help Me Everything
  ####
  robot.hear /(?:a little|some|can you)*(?: )*help(?: )*(?:please|me|me please)* with (?:everything|all)/i, (msg) ->
    message = ""
    message = message + getHelpSearches(message)
    message = message + getHelpExecutions(message)
    

    msg.reply message

  ####
  # Get Release Notes
  ####
  robot.hear /(?:get|show|show[ ]*me)(?: )*(?:the)*(?: )*(?:release notes|notes|rnotes|release|releases)/i, (msg) ->
    message = "\n"
    message = message + getReleaseNotes(message)
    msg.reply message
