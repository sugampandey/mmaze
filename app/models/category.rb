class Category < ActiveRecord::Base
  has_many :quizzes, :dependent => :destroy
  has_one :seeder, :as => :seederable
  validates :name, :presence => true
  validates :name, :uniqueness => true
  
  attr_accessible :name, :published
  
  scope :published, lambda { where(:published => true) }
  scope :unpublished, lambda { where(:published => false) }
end
