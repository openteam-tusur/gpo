class CertificatePdf
  attr_reader :certificates, :pdf
  def initialize(args)
    @certificates = args
  end

  def make_pdf
    @pdf = Prawn::Document.new(page_size: 'A4', margin: 0)
    @certificates.each{ |certificate| generate_page certificate }
    pdf.render
  end

  private

  def generate_page(object)
    pdf.image "#{Rails.root}/lib/pdf_templates/#{resolve_image(object)}", at: [0, 841], width: 595, height: 841
    pdf.bounding_box([90, 580], width: 410) do
      pdf.font "#{Rails.root}/app/assets/fonts/PTSans.ttf"
      pdf.text object.participant.last_name, align: :center, size: 24
      pdf.text [object.participant.first_name,object.participant.middle_name].join(" "), align: :center, size: 24

      pdf.move_down 20
      pdf.font "#{Rails.root}/app/assets/fonts/officinaserifboldosc.ttf"
      pdf.text "в процессе обучения принимал/а участие в разработке проекта", align: :center, size: 16, color: '034f9b'

      pdf.move_down 10
      pdf.font "#{Rails.root}/app/assets/fonts/PTSans.ttf"
      pdf.text "#{object.participant.project.title} (#{object.participant.project.cipher})", align: :center, size: 12

      pdf.move_down 25
      pdf.font "#{Rails.root}/app/assets/fonts/officinaserifboldosc.ttf"
      pdf.text "проект выполнялся", align: :center, size: 16, color: '034f9b'

      pdf.move_down 10
      pdf.font "#{Rails.root}/app/assets/fonts/PTSans.ttf"
      pdf.text object.project_reason, align: :center, size: 12

      unless object.project_result.blank?
        pdf.move_down 25
        pdf.font "#{Rails.root}/app/assets/fonts/officinaserifboldosc.ttf"
        pdf.text "результат выполнения проекта", align: :center, size: 16, color: '034f9b'

        pdf.move_down 10
        pdf.font "#{Rails.root}/app/assets/fonts/PTSans.ttf"
        pdf.text object.project_result, align: :center, size: 12
      end
    end

    pdf.start_new_page if certificates.last != object
  end

  def resolve_image(object)
    object.project_result.blank? ? "certificate_blank.png" : 'certificate.png'
  end
end
