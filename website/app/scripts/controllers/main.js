'use strict';

/**
 * @ngdoc function
 * @name websiteApp.controller:MainCtrl
 * @description
 * # MainCtrl
 * Controller of the websiteApp
 */
angular.module('websiteApp')
  .controller('MainCtrl', function ($scope) {
    $scope.awesomeThings = [
      'HTML5 Boilerplate',
      'AngularJS',
      'Karma'
    ];

    $scope.features = [
    	{
    		'title': "Daily Challenges",
    		'description': "Receive daily challenges to remind you of what's important in your life, such as your health, relationships, and leisure time - all integral to your happiness!"
    	},
    	{
    		'title': "Track progress",
    		'description': "Record your experience in completing the challenge each day through text, photo/video so you can look back and see what you've accomplished!"
    	},
    	{
    		'title': "Get motivated",
    		'description': "Get motivated to complete more challenges by seeing your current and streak highest as well as how many challenges you have completed!"
    	}
    ];

    $scope.submit = function(email) {
      console.log(email);
      /*global Built */
      
      Built.init('blt2edd3e168f0a895a','anappleaday');
      Built.Extension.execute('invite', {email: email}, {
        onSuccess: function(data) {
          // executed successfully
          console.log(data.result);
        },
        onError: function() {
          // error
          console.log('fail');
        }
      });
    };
  });
