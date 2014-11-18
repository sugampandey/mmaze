class Admin::TestimonialsController < Admin::BaseController

  def index
    @testimonials = Testimonial.order("created_at ASC").paginate(:per_page => 20, :page => params[:page])
  end
  
  def destroy
    @testimonial = Testimonial.find(params[:id])
    @testimonial.destroy
    redirect_to admin_testimonials_url
  end
end
