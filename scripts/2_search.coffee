# Description:
#   Handle Search Options
#  
# Commands:
#   hubot 
#
# Author:
#   Bren Sapience <brendan.sapience@gmail.com>

utils = require './utils'

MaxResults = process.env.MAX_RESULTS

CallAutomicApi = (URL,MyJsonData,msg,robot) ->

	utils.apicallpost(URL,MyJsonData,msg,robot,
		callback = (msg,jsonbody) ->
			try

				StrResp = ""

				TotalFound = jsonbody['total']
				HasMore = jsonbody['hasmore']
				msg.send " \t Total Objects Found: *#{TotalFound}*"
				for item in jsonbody["data"]
					ColorItem = "#08a033"
					ItName = item['name']
					ItType = item['type']
					StrResp = StrResp + "\n" + "Found: #{ItName} - #{ItType}"
					CreationTime = utils.convertEpochToSpecificTimezone(item['creation_date'])
					ModifiedTime = utils.convertEpochToSpecificTimezone(item['modified_date'])
					UsedTime = utils.convertEpochToSpecificTimezone(item['last_used_date'])
					ObjType = item['type']
					if ObjType == "JOBP"
						ColorItem = "#4651ea"

					msg.send({
						channel: 'gCCmdeFSQJFoLRigB',
						attachments: [
							{
								author_name: "#{item["title"]}",
								text: "",
								color: ColorItem,
								fields: [
									{
						 				"title": "Type",
										"value": "#{item['type']}",
										"short": false
									},
									{
						 				"title": "Arch1",
										"value": "#{item['archive_key1']}",
										"short": true
									},
									{
						 				"title": "Arch2",
										"value": "#{item['archive_key2']}",
										"short": true
									},
									{
										"title": "Created",
										"value": "#{CreationTime}",
										"short": true
									}
									,
									{
										"title": "Modified",
										"value": "#{ModifiedTime}",
										"short": true
									}
									{
										"title": "Name",
										"value": "#{item['name']}",
										"short": false
									},
									{
										"title": "path",
										"value": "#{item['folder_path']}",
										"short": false
									}
									]
							}
						]
					})
			catch error
				msg.send "Oops, Error: #{error}"
	)


module.exports = (robot) ->

	# Search by Name
	robot.respond /search[ ]+for[ ]+(.*)/i, (msg) ->
		SearchPattern = msg.match[1]
		URL="/search"
		MyJsonData =
			{
				"filters": [{
					"filter_identifier": "object_name",
					"object_name": "#{SearchPattern}"
				}
				,{
						"filter_identifier": "object_type",
						"object_types": ["JOBS","JOBP","PRPT","CONN","JSCH","LOGIN","CALL"]
				}
				],
				"max_results": MaxResults
			}
		CallAutomicApi(URL,MyJsonData,msg,robot)

	# Search by Name And Type
	robot.respond /search[ ]+(.+)[ ]+for[ ]+(.*)/i, (msg) ->
		ObjectTypes = msg.match[1]
		ObjectTypesArray = ObjectTypes.split(",")
		SearchPattern = msg.match[2]
		if SearchPattern.indexOf(" in ") == -1 
			URL="/search"
			MyJsonData =
				{
					"filters": [{
						"filter_identifier": "object_name",
						"object_name": "#{SearchPattern}"
					}
					,{
						"filter_identifier": "object_type",
						"object_types": ObjectTypesArray #["JOBS","JOBP"]
					}
					],
					"max_results": MaxResults
				}
			CallAutomicApi(URL,MyJsonData,msg,robot)

	# Search by Name And Type And Location
	robot.respond /search[ ]+(.+)[ ]+for[ ]+(.*)[ ]+in[ ]+(.*)/i, (msg) ->
		ObjectTypes = msg.match[1]
		ObjectTypesArray = ObjectTypes.split(",")
		SearchPattern = msg.match[2]
		FolderPattern = msg.match[3]
		console.log("IN:"+FolderPattern)
		URL="/search"
		MyJsonData =
			{
				"filters": [{
					"filter_identifier": "object_name",
					"object_name": "#{SearchPattern}"
				}
				,{
					"filter_identifier": "object_type",
					"object_types": ObjectTypesArray #["JOBS","JOBP"]
				}
				,{
					"filter_identifier": "location",
					"location": FolderPattern,#"\\PACKAGES",
					"include_subfolders": true,
					"include_links": false
				}
				],
				"max_results": MaxResults
			}
		CallAutomicApi(URL,MyJsonData,msg,robot)