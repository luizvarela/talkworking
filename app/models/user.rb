require 'digest'
class User < ActiveRecord::Base
  attr_accessible :birthday, :email, :hashed_password, :name, :password
  attr_accessor :password
  
  #VALIDATIONS
    validates :email, :uniqueness => true, 
    					:presence => true,
                      :length => { :within => 5..50 }, 
                      :format => { :with => /^[^@][\w.-]+@[\w.-]+[.][a-z]{2,4}$/i }

    validates :password, :length => { :within => 4..20 },
                         :presence => true,
                         :if => :password_required?

    #ASSOCIATIONS
    has_and_belongs_to_many :projects, :uniq => true
    has_many :comments
    has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>" }, 
      :storage => :s3,
        :bucket => :talkworking,
        :s3_credentials => {
          :access_key_id => "AKIAIPRGGSYW3VAZHR3A",
          :secret_access_key => "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"
        }
    #FILTERS
    before_save :encrypt_new_password
    before_save :set_to_active

    def set_to_active
      self.active = 1
    end

    #METHODS
    def self.authenticate(email, password)
      user = find_by_email(email)
      return user if user && user.authenticated?(password)
    end

    def authenticated?(password)
      self.hashed_password == encrypt(password)
    end
    
    def self.random_password()
      chars = (('a'..'z').to_a + ('0'..'9').to_a) - %w(i o 0 1 l 0)
      (1..8).collect{|a| chars[rand(chars.size)] }.join
    end
    
    protected
      def encrypt_new_password
        return if password.blank?
        self.hashed_password = encrypt(password)
      end
      
      def set_to_active
        self.active = 1
      end
      
      def password_required?
        hashed_password.blank? || password.present?
      end

      def encrypt(string)
        Digest::SHA1.hexdigest(string)
      end
  
end
