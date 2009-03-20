require 'digest/sha1'

class User < ActiveRecord::Base
  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken
  include Authorization::AasmRoles

  OPTIONS = {
    :lockout_period => 1,
    :login_attempts => 3,
    :attempt_window => 4
  }
  
  has_many :login_attempts
  
  validates_presence_of     :login
  validates_length_of       :login,    :within => 3..40
  validates_uniqueness_of   :login
  validates_format_of       :login,    :with => Authentication.login_regex, :message => Authentication.bad_login_message

  validates_format_of       :name,     :with => Authentication.name_regex,  :message => Authentication.bad_name_message, :allow_nil => true
  validates_length_of       :name,     :maximum => 100

  validates_presence_of     :email
  validates_length_of       :email,    :within => 6..100 #r@a.wk
  validates_uniqueness_of   :email
  validates_format_of       :email,    :with => Authentication.email_regex, :message => Authentication.bad_email_message

  named_scope :with_allowed_states, :conditions => { :state => [ 'suspended', 'locked_out', 'active' ] }
  
  aasm_state :locked_out, :enter => :set_locked_out_at
  aasm_event :lock_out do
    transitions :from => :active, :to => :locked_out
  end
  aasm_event :end_lock_out do
    transitions :from => :locked_out, :to => :active
  end

  # HACK HACK HACK -- how to do attr_accessible from here?
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :email, :name, :password, :password_confirmation

  def max_login_attempts?
    self.login_attempts.by_attempt_window(OPTIONS[:attempt_window]).all.size > OPTIONS[:login_attempts]
  end
  
  def lock_out_ended?
    self.locked_out_at < (Time.now - OPTIONS[:lockout_period].minutes)
  end
  
  def login=(value)
    write_attribute :login, (value ? value.downcase : nil)
  end

  def email=(value)
    write_attribute :email, (value ? value.downcase : nil)
  end

  def admin?
    self.role == 'admin'
  end
  
protected
  
  def set_locked_out_at
    self.locked_out_at = Time.now
  end
  
  def make_activation_code
    self.deleted_at = nil
    self.activation_code = self.class.make_token
  end
end
