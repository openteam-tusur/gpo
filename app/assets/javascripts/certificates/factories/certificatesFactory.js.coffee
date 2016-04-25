angular.module('certificates').
  factory('certificatesFactory',['$http', '$window',
    ($http, $window) ->
      o = {
        certificates: []
        url: $window.location.href
        filters: []
      }

      o.filterState = (state, show_new = false) ->
        results = o.certificates.filter (certificate) ->
          certificate.state == state || (!certificate.state && show_new)

      o.selected = () ->
        o.certificates.filter (certificate) ->
          certificate.selected == true

      o.markAll = (selected = false) ->
        console.log selected
        if selected
          o.filterState('published').map (certificate) -> certificate.selected = true
        else
          o.certificates.map (certificate) -> certificate.selected = false

      o.getAllCertificatesUrl = () ->
        "#{o.url}pdf_all?certificates[]=#{o.selected().map((certificate) -> certificate.id ).join('&certificates[]=')}"

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

      o.canPdfAll = (state) ->
        o.filterState(state).filter( (certificate) ->
          certificate.abilities.pdf).length

      o.newCertificate = (hash) ->
        if hash
          certificate = hash
        else
          certificate = {
            participant: {}
            project_result: ''
            project_reason: ''
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

        certificate.formShow = () ->
          certificate.needs_to_be_edited

        certificate.hideForm = () ->
          @needs_to_be_edited = false
          unless @id
            index = o.certificates.indexOf @
            o.certificates.splice(index, 1)

        certificate.counter = (string) ->
          210 - string.length

        certificate.validate = () ->
          @counter(@project_result) >= 0 &&
          @counter(@project_reason) >= 0 &&
          @participant.name

        certificate.saveButtonText = () ->
          if @id then "Сохранить" else 'Добавить'

        certificate.approveButtonText = () ->
          if @state == 'send_to_manager' then 'Согласовать' else 'Отправить на согласование'

        certificate.textForSelectButton = () ->
          if @selected then 'Снять выделение' else 'Выбрать для экспорта'

        certificate
      return o
])
