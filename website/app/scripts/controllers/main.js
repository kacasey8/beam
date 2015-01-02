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
      // Built.Extension.execute('invite', {email: email}, {
      //   onSuccess: function(data) {
      //     // executed successfully
      //     console.log(data);
      //   },
      //   onError: function() {
      //     // error
      //     console.log('fail');
      //   }
      // });
    };
  });
