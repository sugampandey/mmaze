class Testimonial < ActiveRecord::Base
  validates :name, :presence => true
  validates :content, :presence => true
  attr_accessible :name, :content
end
