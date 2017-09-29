class User < ApplicationRecord
  # Direct associations

  has_many   :photos,
             :dependent => :destroy

  has_many   :likes,
             :dependent => :destroy

  has_many   :received_friends_request,
             :class_name => "FriendsRequest",
             :foreign_key => "recipient_id",
             :dependent => :destroy

  has_many   :friends_requests,
             :foreign_key => "sender_id",
             :dependent => :destroy

  # Indirect associations

  has_many   :liked_photos,
             :through => :likes,
             :source => :photo

  # Validations

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end
