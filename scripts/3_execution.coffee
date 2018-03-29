# Description:
#   Handle Executions Options
#  
# Commands:
#   hubot 
#
# Author:
#   Bren Sapience <brendan.sapience@gmail.com>

utils = require './utils'

CallAutomicApiPost = (URL,MyJsonData,msg,robot) ->

	utils.apicallpost(URL,MyJsonData,msg,robot,
		callback = (msg,jsonbody) ->
			try
				if jsonbody['error']
					DisplayResourceError(msg,jsonbody)
				else
					RunID = jsonbody['run_id']
					msg.send " \t Runid: *#{RunID}*"
				
			catch error
				msg.send "Oops, Error: #{error}"
	)

DisplayResourceError = (msg,jsonbody) ->
	try
		ErrorCode = jsonbody['code']
		ErrorMsg = jsonbody['error']
		ErrorDetails = jsonbody['details']
		
		AbendColor = "#c1220d"

		msg.send({
			channel: 'gCCmdeFSQJFoLRigB',
			attachments: [
				{
					author_name: "Error",
					text: "",
					color: AbendColor,
					fields: [
						{
						 	"title": "code",
							"value": "#{ErrorCode}",
							"short": true
						},
						{
						 	"title": "message",
							"value": "#{ErrorMsg}",
							"short": true
						},
						{
						 	"title": "details",
							"value": "#{ErrorDetails}",
							"short": true
						}
					]
				}
			]
		})
	catch error
		msg.send "Oops, Error: #{error}"

DisplayExecution = (msg,jsonbody) ->
	try
		ObjName = jsonbody['name']
		ObjType = jsonbody['type']
		ObjRunID = jsonbody['run_id']
		ObjStatus = jsonbody['status']
		ObjStatusName = jsonbody['status_text']
		ObjRuntime = jsonbody['runtime']
		ObjActTime = jsonbody['activation_time']
		ObjStartTime = jsonbody['start_time']
		ObjEndTime = jsonbody['end_time']
		ObjParent = jsonbody['parent']
		ObjUser = jsonbody['user']

		ColorItem = "#aaa7a7"
		AbendColor = "#c1220d"
		AnyOKColor = "#28d659"
		ActiveColor = "#cfd6d2" #1550
		WorkflowBlockedColor = "#ffef0f" #1560
		WaitingColor = "#21a9ff" #1681 to 1698
		RollbackColor = "#cb91f2" #1650 to 1655

		if ObjStatus >= 1800 and ObjStatus < 1900
			ColorItem = AbendColor
		if ObjStatus >= 1900 and ObjStatus < 2000
			ColorItem = AnyOKColor
		if ObjStatus == 1550
			ColorItem = ActiveColor
		if ObjStatus == 1560
			ColorItem = WorkflowBlockedColor
		if ObjStatus >= 1681 and ObjStatus <= 1698
			ColorItem = WaitingColor
		if ObjStatus >= 1650 and ObjStatus <= 1655
			ColorItem = RollbackColor

		msg.send({
			channel: 'gCCmdeFSQJFoLRigB',
			attachments: [
				{
					author_name: "#{ObjName}",
					text: "",
					color: ColorItem,
					fields: [
						{
						 	"title": "Type",
							"value": "#{ObjType}",
							"short": true
						},
						{
						 	"title": "RunID",
							"value": "#{ObjRunID}",
							"short": true
						},
						{
						 	"title": "Status Code",
							"value": "#{ObjStatus}",
							"short": true
						},
						{
							"title": "Runtime",
							"value": "#{ObjRuntime}",
							"short": true
						},
						{
							"title": "Status Name",
							"value": "#{ObjStatusName}",
							"short": false
						},
						{
							"title": "Start Time",
							"value": "#{ObjStartTime}",
							"short": true
						},
						{
							"title": "End Time",
							"value": "#{ObjEndTime}",
							"short": true
						},
						{
							"title": "Activation Time",
							"value": "#{ObjActTime}",
							"short": true
						},
						{
							"title": "User",
							"value": "#{ObjUser}",
							"short": true
						}
					]
				}
			]
		})
	catch error
		msg.send "Oops, Error: #{error}"

CallAutomicApiGet = (URL,msg,robot) ->

	utils.apicallget(URL,msg,robot,
		callback = (msg,jsonbody) ->
			DisplayExecution(msg,jsonbody)
	)

module.exports = (robot) ->

	# Run with parameters
	robot.respond /NOTREACHABLE/i, (msg) ->
		ObjName = msg.match[1]
		URL="/executions"
		MyJsonData =
			{
				"object_name": "#{ObjName}",
				"inputs":
					{
						"TEXT1#": "passed text",
						"NUMBER1#": "1234",
						"COMBOBOX1#": "Installation",
						"RADIOGROUP1#": "Windows",
						"CHECKBOX1#": ["Low", "Critical", "Irrelevant"],
						"DATETIME1#": "170730",
						"TEXT100#": "another passed text",
						"NUMBER100#": "7777"
					}
			}

		CallAutomicApiPost(URL,MyJsonData,msg,robot)

	# Run
	robot.respond /(?:run|start|trigger|execute)\s*(?:object|job|jobs|workflow|jobplan|jobp|scri|script)*\s+(.*)/i, (msg) ->
		ObjName = msg.match[1]
		URL="/executions"
		MyJsonData =
			{
				"object_name": "#{ObjName}",
			}

		CallAutomicApiPost(URL,MyJsonData,msg,robot)

	# Rerun
	robot.respond /(?:rerun|restart|recover|reexecute)\s*(?:object|job|jobs|workflow|jobplan|jobp|scri|script|run|execution)*\s+(.*)/i, (msg) ->
		ObjRunid = msg.match[1]
		URL="/executions/#{ObjRunid}/status"
		MyJsonData =
			{
				"action": "restart",
			}

		CallAutomicApiPost(URL,MyJsonData,msg,robot)

	# Cancel
	robot.respond /(?:cancel|stop|abort|fail)\s*(?:object|job|jobs|workflow|jobplan|jobp|scri|script|run|execution)*\s+(.*)/i, (msg) ->
		ObjRunid = msg.match[1]
		URL="/executions/#{ObjRunid}/status"
		MyJsonData =
			{
				"action": "cancel",
				"cancel": {
					"recursive": true
				}
			}

		CallAutomicApiPost(URL,MyJsonData,msg,robot)


	# Get Execution
	robot.respond /(?:get|check|look|lookup)\s*(?:job|jobs|jobp|jobplan|run|execution|runid)+\s+(.*)/i, (msg) ->
		ObjRunID = msg.match[1]
		URL="/executions/#{ObjRunID}"

		utils.apicallget(URL,msg,robot,
			callback = (msg,jsonbody) ->
				if jsonbody['error']
					DisplayResourceError(msg,jsonbody)
				else
					DisplayExecution(msg,jsonbody)
		)


	# Get Execution's Children
	robot.respond /(?:get|check|look|lookup)\s*(?:children|children of|child|child of)+\s*(?:job|jobs|jobp|jobplan|run|execution|runid)+\s+(.*)/i, (msg) ->
		ObjRunID = msg.match[1]
		URL="/executions/#{ObjRunID}/children"

		utils.apicallget(URL,msg,robot,
			callback = (msg,jsonbody) ->
				if jsonbody['error']
					DisplayResourceError(msg,jsonbody)
				else
					TotalFound = jsonbody['total']
					HasMore = jsonbody['hasmore']
					msg.send " \t Total Children Found: *#{TotalFound}*"
					if TotalFound > 0
						for item in jsonbody["data"]
							DisplayExecution(msg,item)
		)



