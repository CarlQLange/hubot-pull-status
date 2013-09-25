hubot-pull-status
=================

Hubot can notify your QA team of a new pull request for testing. Then, your QA team can say

	@hubot #422 is good

which uses github's status api to show that pull as ready to merge (prior to this they show as pending).

Your team can also do

	@hubot #422 is bad
	@hubot #422 is really bad

Good? Good. Carl out.
