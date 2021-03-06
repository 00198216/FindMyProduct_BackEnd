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

class Api::V1::ListsController < ApplicationController
   
            rescue_from ActiveRecord::RecordNotFound, :with => :task_not_found
            before_action :authenticate_request!, except: [:index,:show]
            before_action :load_current_user!, only: [:create]

  #Muestra todas las listas
    def index
            
        @lists= List.all


      end

#Elimina un producto de una lista
def create
    @list = List.new(list_params)
    @list.quantity=0
    @current_user.lists << @list
    if @list.save
      render json: {status: "List created successfully"}, status: 201
      @User = @current_user
      @all= List.all
      @message=
        Jbuilder.encode  do |json|
        json.info @all do |list|  
        json.id list.id
        json.name list.name
        json.creation list.created_at
        json.users list.users do |user|
          json.user_id user.id
          json.username user.username
          end
        json.products list.products do |product|
        json.product_id product.id
        json.product_name product.name
        @help= @association= ListProduct.find_by(
            list_id: list.id,
            product_id: product.id)
        json.product_quantity @help.quantity
        json.product_descripcion @help.description
         json.product_status @help.checked
        end
    end
  end
    ActionCable.server.broadcast 'super_channel', message: @message
    else
      render :json => { :errors => @list.errors.full_messages }, status: :bad_request
    end
  end

#Elimina un producto de una lista
  def update
    
      @List=List.find_by(id: params[:id])

      if @List.update(list_params)
        render json: {status: "list updated"}, status: 201
        @User = @current_user
        @all= List.all
        @message=
          Jbuilder.encode  do |json|
          json.info @all do |list|  
          json.id list.id
          json.name list.name
          json.creation list.created_at
          json.users list.users do |user|
            json.user_id user.id
            json.username user.username
            end
          json.products list.products do |product|
          json.product_id product.id
          json.product_name product.name
          @help= @association= ListProduct.find_by(
              list_id: list.id,
              product_id: product.id)
          json.product_quantity @help.quantity
          json.product_descripcion @help.description
           json.product_status @help.checked
          end
      end
    end
      ActionCable.server.broadcast 'super_channel', message: @message
      else
        render :json => { :errors => @list.errors.full_messages }, status: 400
      end
  
  end

 
      #Mostrar los usuarios de una lista
      def users
        @list = List.find_by(id: params[:id])
        
      end

   #Muestra los productos de una lista
   def users
    @list = List.find_by(id: params[:id])
  
  end

#Elimina una lista
  def destroy
    @List= List.find(params[:id])
    if @List.destroy
      render json: { message: "List Successfully Deleted." }, status: 200
      @User = @current_user
      @all= List.all
      @message=
        Jbuilder.encode  do |json|
        json.info @all do |list|  
        json.id list.id
        json.name list.name
        json.creation list.created_at
        json.users list.users do |user|
          json.user_id user.id
          json.username user.username
          end
        json.products list.products do |product|
        json.product_id product.id
        json.product_name product.name
        @help= @association= ListProduct.find_by(
            list_id: list.id,
            product_id: product.id)
        json.product_quantity @help.quantity
        json.product_descripcion @help.description
         json.product_status @help.checked
        end
    end
  end
    ActionCable.server.broadcast 'super_channel', message: @message
    else
      list_not_found
    end
 
  end

  #Muestra una lista
  def show
    @list = List.find_by(id: params[:id])

  end

  private
  def list_params
    params.require(:list).permit(:name)
  end


  private
  def product_params
    params.require(:product).permit(:name)
  end
 
end
 