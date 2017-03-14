jsdom = require "jsdom"

module.exports = (robot) ->
  robot.hear /riddle me this[?]/i, (res) ->
    jsdom.env 'http://goodriddlesnow.com/riddles/random', [ 'http://code.jquery.com/jquery.js' ], (err, window) ->
      $ = window.$
      riddle = $('body .riddle-question p').text()
      answer = $('body .riddle-answer p:first').text()
      robot.brain.set 'answer', answer
      res.reply riddle
    return
  robot.hear /riddle me that[?]/i, (res) ->
    correctAnswer = robot.brain.get('answer')
    res.reply correctAnswer
    return
  robot.hear /riddle me done[!]\s*(.*)/i, (res) ->
    userAnswer = res.match[1].toLowerCase()
    correctAnswer = robot.brain.get('answer').toLowerCase()
    if !userAnswer or correctAnswer.indexOf(userAnswer) == -1
      res.reply 'Wrong! It doesn\'t suprise me that I out smarted you.'
    else
      robot.brain.set 'answer', ''
      res.reply 'Well would you look at that! You do have the ability to think. ' + 'Alas! Don\'t get too comfortable, because the next one will be much harder.'
    return
  return
