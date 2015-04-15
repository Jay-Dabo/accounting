class Subscriber < ActiveRecord::Base
  validates :email, :format => { :with => %r{.+@.+\..+} }#, #:allow_blank => true	
end
