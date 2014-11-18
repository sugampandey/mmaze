class MainController < ApplicationController

  def index
  end

  def contactus
    @contact = Contact.new
  end

  def testimonial
    testimonial = Testimonial.new({:name => params[:name], :content => params[:content]})
    testimonial.save
    respond_to do |format|
      format.js { render :json => { :status => true }.to_json }
    end
  end
end
