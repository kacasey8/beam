var config = require('./config.js');
Built.initialize('blt2edd3e168f0a895a', 'anappleaday');
Built.Extension.beforeSave('usersChallenges', function(request, response) {
  var user = request.object.get('user');
  var challenge = request.object.get('challenge');
  var challenge_query = new Built.Query('challenge');
  challenge_query.where('uid', challenge);

  challenge_query.exec({
    onSuccess: function(data) {
      var date_str = data[0].get('date');
      var date = new Date(date_str);
      var user_query = new Built.Query('built_io_application_user');
      user_query.where('uid', user);
      user_query.exec({
        onSuccess: function(data) {
          var user_object = data[0];
          var last_completed = new Date(user_object.get('last_date_completed'));
          if(last_completed == date) {
            return; // Updated the challenge, nothing to do.
          }

          var day_before_last_completed = new Date(last_completed.getDate() - 1);

          var current_streak = user_object.get('current_streak');
          var highest_streak = user_object.get('highest_streak');

          if (day_before_last_completed == date) {
            // They added to the current streak.
            current_streak += 1;
          } else {
            // Broke the current streak, starting new one.
            current_streak = 1;
          }

          highest_streak = Math.max(highest_streak, current_streak);


          user_object.set({
            current_streak: current_streak,
            highest_streak: highest_streak,
            last_date_completed: date_str
          });

          user_object.setMasterKey(config.masterKey());
           
          user_object.save({
            onSuccess: function(data, res) {
              // object update is successful

              // Standard string formatting
              if (!String.prototype.format) {
                String.prototype.format = function() {
                  var args = arguments;
                  return this.replace(/{(\d+)}/g, function(match, number) { 
                    return typeof args[number] != 'undefined'
                      ? args[number]
                      : match
                    ;
                  });
                };
              }
              console.log("SUCCESS - user: {0}, current_streak: {1}, highest_streak: {2}, last_date_completed: {3}".format(user, highest_streak, current_streak, date_str));
            },
            onError: function(err) {
              // some error has occurred
              // refer to the "error" object for more details
              console.log("ERROR");
              console.log(err);
            }
          });
        },
        onError: function(err) {
          console.log("ERROR");
          console.log(err);
        }
      });
    },
    onError: function(err) {
      console.log("ERROR");
      console.log(err);
    }
  });
  return response.success();
});