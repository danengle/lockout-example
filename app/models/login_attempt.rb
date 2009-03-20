class LoginAttempt < ActiveRecord::Base
  belongs_to :user
  
  named_scope :by_attempt_window, lambda { |attempt_window| { :conditions => [ 'created_at > ?', Time.now - attempt_window.minutes ] } }
end
