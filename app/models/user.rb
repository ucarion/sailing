class User < ActiveRecord::Base
  attr_accessible :email, :name

  before_save { |user| user.email = email.downcase }

  EMAIL_REGEX = /\A\w+@\w+\.[a-z]+\z/i

  validates :name,  presence: true
  validates :email, presence: true,
                    format: { with: EMAIL_REGEX }
                    uniqueness: { case_sensitive: false }
end
