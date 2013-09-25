github = require 'githubot'

REPO = process.env["HUBOT_GITHUB_REPO"]
USERS_TO_NOTIFY = ["Carl Lange"]

module.exports = (robot) ->
	github = github robot

	robot.hear /opened pull request (\d*)/i, (msg) ->
		pull_number = msg.match[1]

		github.get "repos/#{REPO}/pulls/#{pull_number}", (pull_data) ->
			pull_sha = pull_data.head.sha
			github.post "repos/#{REPO}/statuses/#{pull_sha}", { state: 'pending', description: 'Awaiting approval by QA.' }, ->

		message = "New pull request ##{pull_number} is awaiting approval. http://github.com/fluidsoftware/fluidui/pull/#{pull_number}"

		for user in USERS_TO_NOTIFY
			robot.send user: robot.brain.userForName(user), message

	robot.respond /#(\d+)\s+is\s+good.*/i, (msg) ->
		pull_number = msg.match[1]
		
		github.get "repos/#{REPO}/pulls/#{pull_number}", (pull_data) ->
			pull_sha = pull_data.head.sha
			github.post "repos/#{REPO}/statuses/#{pull_sha}", { state: 'success', description: 'Approved by QA!' }, ->

	robot.respond /#(\d+)\s+is\sbad.*/i, (msg) ->
		pull_number = msg.match[1]
		
		github.get "repos/#{REPO}/pulls/#{pull_number}", (pull_data) ->
			pull_sha = pull_data.head.sha
			github.post "repos/#{REPO}/statuses/#{pull_sha}", { state: 'failure', description: 'QA thinks this is broken.' }, ->
	
	robot.respond /#(\d+)\s+is\sreally\sbad.*/i, (msg) ->
		pull_number = msg.match[1]

		github.get "repos/#{REPO}/pulls/#{pull_number}", (pull_data) ->
			pull_sha = pull_data.head.sha
			github.post "repos/#{REPO}/statuses/#{pull_sha}", { state: 'error', description: 'QA thinks this is completely unshippable' }, ->
