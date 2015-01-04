var config = require('./config.js');
Built.initialize('blt2edd3e168f0a895a', 'anappleaday');

Built.Extension.define('invite', function(request, response) {
  var invitees = Built.Object.extend('invitees');
  var invitee = new invitees();
  invitee.set({
    email: request.params.email
  });
  invitee.save({
    onSuccess: function(data, res) {
      // object creation is successful
      return response.success(request.params.email);
    },
    onError: function(err) {
      // some error has occurred
      // refer to the "error" object for more details
      console.log(err);
    }
  });
});

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
          if(last_completed.getTime() == date.getTime()) {
            return; // Updated the challenge, nothing to do.
          }

          var day_after_last_completed = new Date(last_completed);
          day_after_last_completed.setDate(day_after_last_completed.getDate() + 1);

          var current_streak = user_object.get('current_streak');
          var highest_streak = user_object.get('highest_streak');

          if (day_after_last_completed.getTime() == date.getTime()) {
            // They added to the current streak.
            current_streak += 1;
          } else {
            // Broke the current streak, starting new one.
            current_streak = 1;
          }

          console.log("before" + highest_streak);
          highest_streak = Math.max(highest_streak, current_streak);
          console.log("after" + highest_streak);

          user_object.set({
            current_streak: current_streak,
            highest_streak: highest_streak,
            last_date_completed: date_str
          });

          user_object.setMasterKey(config.masterKey());
           
          user_object.save({
            onSuccess: function(data, res) {
              // object update is successful
              console.log("someone posted");
              console.log(user_object);
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

var sendNotification = function() {
  Built.User.login(
    config.notification_user_email(),
    config.notification_user_password(),
    { 
      onSuccess: function(data, res) {
        // you have successfully logged in
        // data.application_user will contain the profile
        Built.setHeaders('authtoken', data.application_user.authtoken);
        var user_query = new Built.Query('built_io_application_user');

        user_query.only(['uid', 'last_date_completed', 'first_name']);

        user_query.exec({
          onSuccess: function(data) {
            var user_uids = [];

            var today = new Date();

            today.setHours(today.getHours() - 8); // Convert to PST time.

            // No time, only date.
            today.setHours(0,0,0,0);

            for (i = 0; i < data.length; i++) { 
              console.log(data[i]);
              var last_date = new Date(data[i].get('last_date_completed'));

              if (today.getTime() != last_date.getTime()) {
                user_uids.push(data[i].get('uid'));
                console.log('sending to: ' + data[i].get('first_name'));
              } else {
                console.log('not sending to: ' + data[i].get('first_name'));
              }
            }

            var notification = new Built.Notification();
            notification.addUsers(user_uids);

            // Don't send in local time. It'll get confusing. For now just send immediately
            // based on whether they finished at the send time.
            // var d = new Date();
            // d.setHours(24 + 9,0,0,0); // next 9 am
            //notification.atTime(d).inLocalTime(true).setMessage("Remember to complete today's challenge");

            notification.setMessage("Remember to complete today's challenge!");
            console.log('about to send');
            notification.send({
              onSuccess: function(data) {
                console.log("Notification - Success");
                console.log(data);
              },
              onError: function(err) {
                console.log("Notification - ERROR");
                console.log(err);
              }
            });
          },
          onError: function(err) {
            console.log("ERROR");
            console.log(err);
          }
        });
      }
    }
  );
}

//84000 seconds in a day, 1000 milliseconds in a second. Activated once a day
function sendDailyNotification() {
  // Send one now, since set interval does not send immediately
  sendNotification();
  setInterval(sendNotification, 84000 * 1000);
}

var now = new Date();
// Trigger at 12PM PST time
var hour = 20; // Server is running in UTC time
var millisTill12 = new Date(now.getFullYear(), now.getMonth(), now.getDate(), hour, 0, 0, 0) - now;
if (millisTill12 < 0) {
     millisTill12 += 86400000; // it's after 12pm, try 12pm tomorrow.
}
setTimeout(sendDailyNotification, millisTill12);
