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
