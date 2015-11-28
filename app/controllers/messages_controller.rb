class MessagesController < ApplicationController
	before_action :require_user, only: [:new, :create, :edit, :update, :destroy]

	def index
		@messages = Message.all
	end
	def show
		@message = Message.find(params[:id])
	end

	def new
		@message = Message.new
	end
	def create
		@message = Message.new
		@message.author = current_user.login
		if @message.update(message_params)
			redirect_to message_path(@message.id)
		else
			render 'new'
		end
	end
	
	def edit
		@message = Message.find(params[:id])
	end
	def update
		@message = Message.find(params[:id])
		if @message.update(message_params)
			redirect_to @message
		else
			render 'edit'
		end
	end
	
	def destroy
		@message = Message.find(params[:id])
    	@message.destroy
    	redirect_to root_url
	end

	private
    def message_params
      params.require(:message).permit(:content)
    end
end
