request = require 'request'
http = require 'http'
fs = require 'fs'


ExtAPIURL = process.env.API_EXT_HOST

HTTP_OR_HTTPS = process.env.HTTP_OR_HTTPS
AE_HOST = process.env.AUTOMIC_HOSTNAME_OR_IP
REST_PORT = process.env.AUTOMIC_AE_REST_PORT
REST_PATH = process.env.AUTOMIC_AE_REST_PATH
CLIENT = process.env.AUTOMIC_AE_CLIENT

LOGIN = process.env.AUTOMIC_AE_LOGIN
PWD = process.env.AUTOMIC_AE_PWD

# Runs an API standard Call.. POST
module.exports.apicallpost = (urlext,MyJsonData,msg,robot,processbody) ->

  auth = 'Basic ' + new Buffer(LOGIN + ':' + PWD).toString('base64')

  url = "#{HTTP_OR_HTTPS}#{AE_HOST}:#{REST_PORT}#{REST_PATH}#{CLIENT}#{urlext}"

  data = JSON.stringify(MyJsonData)
  #console.log(data)
  robot.http(url)
    .header('Authorization',auth)
    .header('Content-Type','application/json')
    .post(data) (err,res,jsonbody) ->
      JsonResp = JSON.parse(jsonbody)

      processbody(msg,JsonResp)

# Runs an API standard Call.. GET
module.exports.apicallget = (urlext,msg,robot,processbody) ->
  
  auth = 'Basic ' + new Buffer(LOGIN + ':' + PWD).toString('base64')

  url = "#{HTTP_OR_HTTPS}#{AE_HOST}:#{REST_PORT}#{REST_PATH}#{CLIENT}#{urlext}"

  robot.http(url)
    .header('Authorization',auth)
    .header('Content-Type','application/json')
    .get() (err,res,jsonbody) ->
      JsonResp = JSON.parse(jsonbody)

      processbody(msg,JsonResp)

module.exports.convertEpochToSpecificTimezone = (edate) ->
  
  date = new Date(edate);
  Year = date.getFullYear();
  Month = date.getMonth()+1;
  if Month < 10
    Month = "0"+Month
  Day = date.getDate();
  if Day < 10
    Day = "0"+Day
  hours = date.getHours();
  minutes = "0" + date.getMinutes();
  seconds = "0" + date.getSeconds();

  formattedTime = Year+ '-' +Month+'-'+Day+' ' +hours + ':' + minutes.substr(-2) + ':' + seconds.substr(-2);
  return formattedTime;
