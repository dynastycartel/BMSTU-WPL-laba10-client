# frozen_string_literal: true

# helping me
module PalindromsHelper
  SERV_TRANS = "#{Rails.root}/public/transform.xslt".freeze
  BROWS_TRANS = '/transform.xslt'

  def validate_input
    flash[:warning] = 'Заполните поле ввода' if params[:user_input] == ''
    user_input = params[:user_input].to_i
    flash[:notice] = 'Введите число от 1 до 1.000.000' if user_input.to_i < 1 || user_input.to_i > 1_000_000
  end

  def insert_xslt_line(data, transform: BROWS_TRANS)
    doc = Nokogiri::XML(data)
    xslt = Nokogiri::XML::ProcessingInstruction.new(
      doc, 'xml-stylesheet', "type=\"text/xsl\" href=\"#{transform}\""
    )
    doc.root.add_previous_sibling(xslt)
    doc
  end

  def xslt_trans(data, transform: SERV_TRANS)
    doc = Nokogiri::XML(data)
    xslt = Nokogiri::XSLT(File.read(transform))
    xslt.transform(doc)
  end

  def print_result(side, server_response)
    case side
    when 'server'
      render inline: xslt_trans(server_response).to_html
    when 'html'
      render xml: insert_xslt_line(server_response)
    when 'xml'
      render xml: server_response
    end
  end
end
