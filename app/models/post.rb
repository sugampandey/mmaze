class Post < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title, :use => :slugged

  attr_accessible :title, :body
  
  validates :title, :body, :slug, :presence => true
  # validates :user_id, :state, :presence => true
  
  state_machine :initial => 'drafted' do
    event :publish do
      transition :from => ['drafted', 'unpublished'], :to => 'published'
    end
    event :unpublish do
      transition :from => ['published'], :to => 'unpublished'
    end
  end
  
  state_machine.states.map do |state| 
    scope state.name, :conditions => { :state => state.name.to_s } 
  end
end
