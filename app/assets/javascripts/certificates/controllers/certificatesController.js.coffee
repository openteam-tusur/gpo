angular.module('certificates')
  .controller('CertificatesController',[ '$scope', 'certificatesFactory',
    ($scope, certificates) ->
      $scope.certificates = certificates
      $scope.new_form = true
      $scope.new_certificate = {}
    ])
