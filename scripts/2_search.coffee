# Description:
#   Handle Help Options
#  
#
# Commands:
#   hubot 
#
# Author:
#   Bren Sapience <brendan.sapience@gmail.com>

utils = require './utils'

module.exports = (robot) ->
	robot.respond /test/i, (msg) ->
		URL="/search"
		MyJsonData =
    		{
      			"filters": [{
        			"filter_identifier": "object_name",
        			"object_name": "*"
      			}
      			,{
        			"filter_identifier": "object_type",
        			"object_types": ["JOBS","JOBP"]
      			}
      			],
      			"max_results": 100
    		}

		utils.apicallpost(URL,MyJsonData,msg,robot,
      		callback = (msg,jsonbody) ->
        	try

        		StrResp = ""

        		TotalFound = jsonbody['total']
        		HasMore = jsonbody['hasmore']

        		for item in jsonbody["data"]
          			ItName = item['name']
          			ItType = item['type']
          			
          			StrResp = StrResp + "\n" + "Found: #{ItName} - #{ItType}"
          		msg.send StrResp
        	catch error
        		msg.send "Oops, Error: #{error}"
    	)

    
