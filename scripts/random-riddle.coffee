// Description:
//   The master of conundrums itself, the riddlebot will stump you with only the most difficult riddles.
//
// Commands:
//   riddle me this? - Gives the user a riddle.
//   riddle me that? - Gives the answer to the last riddle given.
//   riddle me done! [user's answer] - Determines whether the user's answer is correct or not.
//
// Author:
//   me

var jsdom = require("jsdom");

module.exports = function (robot) {
  robot.hear(/riddle me this[?]/i, function (res) {
    jsdom.env(
      "http://www.riddles.nu/random",
      ["http://code.jquery.com/jquery.js"],
      function (err, window) {
        var $ = window.$;
        var question = $('blockquote:first p').text();
        var answer = $('blockquote:first div div').html();
      }
    );
    var riddle = question;
    var answer = answer;

    robot.brain.set('answer', answer);
    res.reply('It\'s time to get smart! ' + riddle);
  });

  robot.hear(/riddle me that[?]/i, function (res) {
    var correctAnswer = robot.brain.get('answer');

    res.reply('Giving up already? Well I should have seen that coming. Here is the answer to that riddle: ' + correctAnswer + ".");
  });

  robot.hear(/riddle me done[!]\s*(.*)/i, function (res) {
    var userAnswer = res.match[1].toLowerCase();
    var correctAnswer = robot.brain.get('answer').toLowerCase();

    if (!userAnswer || correctAnswer.indexOf(userAnswer) === -1) {
      res.reply('Wrong! It doesn\'t suprise me that I out smarted you.');
    } else {
      robot.brain.set('answer', '');
      res.reply('Well would you look at that! You do have the ability to think. ' +
        'Alas! Don\'t get too comfortable, because the next one will be much harder.');
    }
  });
};
