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

# Runs an API standard Call.. This (all calls) leverage the Home API (abstracted Rest API that provides interfaces to all other APIs)
module.exports.apicallpost = (urlext,MyJsonData,msg,robot,processbody) ->
  username = msg.message.user.name
  auth = 'Basic ' + new Buffer(LOGIN + ':' + PWD).toString('base64')

  url = "#{HTTP_OR_HTTPS}#{AE_HOST}:#{REST_PORT}#{REST_PATH}#{CLIENT}#{urlext}"

  data = JSON.stringify(MyJsonData)

  robot.http(url)
    .header('Authorization',auth)
    .header('Content-Type','application/json')
    .post(data) (err,res,jsonbody) ->
      JsonResp = JSON.parse(jsonbody)
      processbody(msg,JsonResp)

