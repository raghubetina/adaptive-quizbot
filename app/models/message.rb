# == Schema Information
#
# Table name: messages
#
#  id         :bigint           not null, primary key
#  content    :text
#  role       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  topic_id   :integer
#
class Message < ApplicationRecord
  belongs_to :topic

  validates :role, presence: true
  validates :content, presence: true
end
