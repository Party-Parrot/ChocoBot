jsdom = require "jsdom"

module.exports = (robot) ->
  robot.hear /riddle me this[?]/i, (res) ->
    jsdom.env 'http://www.riddles.nu/random', [ 'http://code.jquery.com/jquery.js' ], (err, window) ->
      $ = window.$
      global.riddle = $('body blockquote:first p').text()
      res.reply($('body blockquote:first p').text())
      global.answer =  $('body blockquote:first div div').html()
      res.reply($('body blockquote:first div div').html())
      return
    robot.brain.set 'answer', global.answer
    res.reply 'It\'s time to get smart! ' + global.riddle
    return
  robot.hear /riddle me that[?]/i, (res) ->
    correctAnswer = robot.brain.get('answer')
    res.reply 'Giving up already? Well I should have seen that coming. Here is the answer to that riddle: ' + correctAnswer + '.'
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
