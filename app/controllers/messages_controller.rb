class MessagesController < ApplicationController
  def index
    matching_messages = Message.all

    @list_of_messages = matching_messages.order({ :created_at => :desc })

    render({ :template => "messages/index" })
  end

  def show
    the_id = params.fetch("path_id")

    matching_messages = Message.where({ :id => the_id })

    @the_message = matching_messages.at(0)

    render({ :template => "messages/show" })
  end

  def create
    the_message = Message.new
    the_message.topic_id = params.fetch("query_topic_id")
    the_message.content = params.fetch("query_content")

    the_message.role = "user"

    if the_message.valid?
      the_message.save

      # Get all the older messages for this topic from the db

      # the_topic = Topic.where({ :id => the_message.topic_id }).at(0)
      
      the_topic = the_message.topic

      the_history = the_topic.messages.order(:created_at)

      # Reconstruct an AI::Chat from scratch

      chat = OpenAI::Chat.new

      the_history.each do |a_message|
        if a_message.role == "system"
          chat.system(a_message.content)
        elsif a_message.role == "user"
          chat.user(a_message.content)
        else
          chat.assistant(a_message.content)
        end
      end

      # Get the next assistant message

      next_message = Message.new
      next_message.topic_id = the_topic.id
      next_message.role = "assistant"
      next_message.content = chat.assistant!
      next_message.save

      redirect_to("/topics/#{the_message.topic_id}", { :notice => "Message created successfully." })
    else
      redirect_to("/topics/#{the_message.topic_id}", { :alert => the_message.errors.full_messages.to_sentence })
    end
  end

  def update
    the_id = params.fetch("path_id")
    the_message = Message.where({ :id => the_id }).at(0)

    the_message.topic_id = params.fetch("query_topic_id")
    the_message.content = params.fetch("query_content")
    the_message.role = params.fetch("query_role")

    if the_message.valid?
      the_message.save
      redirect_to("/messages/#{the_message.id}", { :notice => "Message updated successfully."} )
    else
      redirect_to("/messages/#{the_message.id}", { :alert => the_message.errors.full_messages.to_sentence })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_message = Message.where({ :id => the_id }).at(0)

    the_message.destroy

    redirect_to("/messages", { :notice => "Message deleted successfully."} )
  end
end
