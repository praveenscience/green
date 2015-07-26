'use strict'

angular.module 'greenApp'
.controller 'AdminCtrl', ($scope, $http, Auth, User) ->

  $http.get '/api/users'
  .success (users) ->
    users.forEach (user) ->
      if user.role is 'admin'
        user.isAdmin = true
      else
        user.isAdmin = false
    $scope.users = users

  $scope.toggleAdminRole = (user) ->
    if user.role is 'admin'
      user.role = 'user'
    else
      user.role = 'admin'
    User.update id: user._id, user

  $scope.isMe = Auth.getCurrentUser()

  $scope.delete = (user) ->
    User.remove id: user._id
    _.remove $scope.users, user
