# FindMyProduct API
# Copyright (C) 2020  00198216
#
# This program is free software: you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation, version 3 of the License.
#
# This program is distributed in the hope that it will be useful, but WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along with
# this program. If not, see <https://www.gnu.org/licenses/>.

class User < ApplicationRecord
    has_many :list_users
    has_many :lists, through: :list_users

    scope :search_name, ->(username) { where("username LIKE ?", "%"+username+"%" ) }  
    
    has_secure_password
    validates :username, presence: true, uniqueness: true
    validates :email, presence: true, uniqueness: true
    validates :phone,:presence => true,
                 :numericality => true,
                 :length => { :minimum => 7, :maximum => 12 }

    #confirmed friends
    has_many :friendships, -> {where(friendships: {confirmed: true})}
    has_many :friends, :through => :friendships
    has_many :inverse_friendships, -> {where(friendships: {confirmed: true})}, :class_name => "Friendship", :foreign_key => "friend_id"
    has_many :inverse_friends, :through => :inverse_friendships, :source => :user

    #pending friends
    has_many :pending_friendships, -> { where(confirmed: false) }, :class_name => "Friendship", :foreign_key => "user_id"                                  
    has_many :pending_friends, through: :pending_friendships, source: :friend

    #requested friends
    has_many :requested_friendships, -> {where(friendships: {confirmed: false})}, :class_name => "Friendship", :foreign_key => "friend_id"                              
    has_many :requested_friends, through: :requested_friendships, source: :user

    def self.confirmed_friends(user)
      a = user.friends.select(:id, :username, :email, :phone)
      b = user.inverse_friends.select(:id, :username, :email, :phone)
      friends_array = a + b
      friends_array.compact
    end

    def self.pending_friends(user)
      user.pending_friends.select(:id, :username, :email, :phone).compact
    end

    def self.requested_friends(user)
      user.requested_friends.select(:id, :username, :email, :phone).compact
    end

    def friend?(other_user)
      friends.include?(other_user) || inverse_friends.include?(other_user)
    end

    def pending?(other_user)
      pending_friends.include?(other_user) || requested_friends.include?(other_user)
    end

end
