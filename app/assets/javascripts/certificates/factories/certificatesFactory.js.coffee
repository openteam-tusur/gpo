angular.module('certificates').
  factory('certificatesFactory',['$http', '$window',
    ($http, $window) ->
      o = {
        certificates: []
        url: $window.location.href
      }

      o.showAddButton = () ->
        blank_certificates = o.certificates.filter (certificate) ->
          certificate.id == null

        roles = o.roles.filter (role) ->
          ['project_manager', 'mentor'].indexOf(role) != -1

        blank_certificates.length == 0 && roles.length > 0

      o.insertData = (array) ->
        for certificate in array
          o.certificates.push o.newCertificate(certificate)

      o.addCertificate = () ->
        for certificate in o.certificates
          certificate.needs_to_be_edited = false
        o.certificates.unshift o.newCertificate()

      o.newCertificate = (hash) ->
        if hash
          certificate = hash
        else
          certificate = {
            participant: {}
            project_result: null
            project_reason: null
            id: null
            needs_to_be_edited: true
            abilities:
              edit_destroy: true
              approve: true
              decline: true
              edit_participant: true
          }

        certificate.submit = () ->
          if @id
            @update()
          else
            @create()

        certificate.create = () ->
          @participant_id = @participant.id
          index = o.certificates.indexOf @
          $http.post("#{o.url}.json", { certificate: certificate }).success (data) ->
            o.certificates[index] = o.newCertificate(data)

        certificate.update = () ->
          @participant_id = @participant.id
          index = o.certificates.indexOf @
          $http.put("#{o.url}/#{@id}.json", { certificate: certificate }).success (data) ->
            o.certificates[index] = o.newCertificate(data)

        certificate.destroy = () ->
          if @id
            $http.delete("#{o.url}/#{@id}.json")
          index = o.certificates.indexOf @
          o.certificates.splice(index, 1)

        certificate.approve = () ->
          @participant_id = @participant.id
          index = o.certificates.indexOf @
          $http.post("#{o.url}/#{@id}/approve.json").success (data) ->
            o.certificates[index] = o.newCertificate(data)

        certificate.decline = () ->
          @participant_id = @participant.id
          index = o.certificates.indexOf @
          $http.post("#{o.url}/#{@id}/decline.json").success (data) ->
            o.certificates[index] = o.newCertificate(data)

        certificate.form_show = () ->
          certificate.needs_to_be_edited

        certificate.hideForm = () ->
          @needs_to_be_edited = false
          unless @id
            index = o.certificates.indexOf @
            o.certificates.splice(index, 1)

        certificate.save_button_text = () ->
          if @id then "Сохранить" else 'Добавить'

        certificate
      return o
    ])
