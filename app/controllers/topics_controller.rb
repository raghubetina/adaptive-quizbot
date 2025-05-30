class TopicsController < ApplicationController
  def index
    matching_topics = Topic.all

    @list_of_topics = matching_topics.order({ :created_at => :desc })

    render({ :template => "topics/index" })
  end

  def show
    the_id = params.fetch("path_id")

    matching_topics = Topic.where({ :id => the_id })

    @the_topic = matching_topics.at(0)

    render({ :template => "topics/show" })
  end

  def create
    the_topic = Topic.new
    the_topic.title = params.fetch("query_title")

    if the_topic.valid?
      the_topic.save

      system_message = Message.new
      system_message.role = "system"
      system_message.topic_id = the_topic.id
      system_message.content = "You are a #{the_topic.title} tutor. Ask the user five questions to assess their Basketball proficiency. Start with an easy question. After each answer, increase or decrease the difficulty of the next question based on how well the user answered.

In the end, provide a score between 0 and 10."

      system_message.save


      user_message = Message.new
      user_message.topic_id = the_topic.id
      user_message.role = "user"
      user_message.content = "Can you assess my #{the_topic.title} proficiency?"
      user_message.save

      c = OpenAI::Chat.new
      c.system(system_message.content)
      c.user(user_message.content)
      next_ai_message_content = c.assistant!

      next_message = Message.new
      next_message.role = "assistant"
      next_message.content = next_ai_message_content
      next_message.topic_id = the_topic.id
      next_message.save

      redirect_to("/topics/#{the_topic.id}", { :notice => "Topic created successfully." })
    else
      redirect_to("/topics", { :alert => the_topic.errors.full_messages.to_sentence })
    end
  end

  def update
    the_id = params.fetch("path_id")
    the_topic = Topic.where({ :id => the_id }).at(0)

    the_topic.title = params.fetch("query_title")

    if the_topic.valid?
      the_topic.save
      redirect_to("/topics/#{the_topic.id}", { :notice => "Topic updated successfully."} )
    else
      redirect_to("/topics/#{the_topic.id}", { :alert => the_topic.errors.full_messages.to_sentence })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_topic = Topic.where({ :id => the_id }).at(0)

    the_topic.destroy

    redirect_to("/topics", { :notice => "Topic deleted successfully."} )
  end
end
