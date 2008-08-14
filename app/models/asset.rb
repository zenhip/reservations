class Asset < ActiveRecord::Base
  
  belongs_to :product
  
  has_attachment :content_type => :image,
                 :storage => :file_system, 
                 :max_size => 20.megabytes,
                 #:resize_to => 'x50',
                 :thumbnails => { 
                   :thumb => '120>',
                   :tiny => '50>' 
                   },
                 :processor => :mini_magick

  validates_as_attachment
  
end
