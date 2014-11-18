class ContactsController < ApplicationController
  def create
  	@contact = Contact.new(params[:contact])
  	if @contact.save
  	  flash[:notice] = "Thank for contacting us!"
      respond_to do |format|
  		format.html { redirect_to root_url }
  	  end
  	else
  	  flash[:notice] = @contact.errors.full_messages.join(", ")
  	  respond_to do |format|
  	    format.html { redirect_to contactus_url }
  	  end
  	end
  end
end
