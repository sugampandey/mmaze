class Seeder < ActiveRecord::Base
  belongs_to :seedable, :polymorphic => true
  has_attached_file :doc,
    :path => ":rails_root/public/system/:attachment/:id/:filename",
    :url => "/system/:attachment/:id/:filename"
validates_attachment_presence :doc
  attr_accessible :doc
end
