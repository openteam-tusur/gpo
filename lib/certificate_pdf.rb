class CertificatePdf
  attr_reader :certificates, :pdf
  def initialize(args)
    @certificates = args
  end

  def make_pdf
    @pdf = Prawn::Document.new(page_size: 'A4', margin: 0)
    pdf.font "#{Rails.root}/app/assets/fonts/PTSans.ttf"
    @certificates.each{ |certificate| generate_page certificate }
    pdf.render
  end

  private

  def generate_page(object)
    pdf.image "#{Rails.root}/lib/pdf_templates/#{resolve_image(object)}", at: [0, 841], width: 595, height: 841
    pdf.move_down 270
    pdf.text object.participant.last_name, align: :center, size: 24
    pdf.text [object.participant.first_name,object.participant.middle_name].join(" "), align: :center, size: 24
    pdf.bounding_box([90, 420], width: 410) do
      pdf.text object.participant.project.title, align: :center, size: 12
    end

    pdf.bounding_box([90, 286], width: 410) do
      pdf.text object.project_reason, align: :center, size: 12
    end

    pdf.bounding_box([90, 195], width: 410) do
      pdf.text object.project_result, align: :center, size: 12
    end unless object.project_result.blank?

    pdf.start_new_page if certificates.last != object
  end

  def resolve_image(object)
    object.project_result.blank? ? "certificate_blank.png" : 'certificate.png'
  end
end
