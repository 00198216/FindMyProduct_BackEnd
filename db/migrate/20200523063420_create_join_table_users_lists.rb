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

class CreateJoinTableUsersLists < ActiveRecord::Migration[6.0]
  def change
    create_join_table :users, :lists do |t|
      # t.index [:user_id, :list_id]
      # t.index [:list_id, :user_id]
    end
  end
end
