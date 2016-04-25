angular.module('certificates')
  .controller('CertificatesController',[ '$scope', 'certificatesFactory',
    ($scope, certificates) ->
      $scope.certificates = certificates
      $scope.new_form = true
      $scope.new_certificate = {}
      $scope.filterState = null

      $scope.resolveState = (state) ->
        state = $scope.certificates.filters[0].state unless state
        $scope.filterState = state
    ])
