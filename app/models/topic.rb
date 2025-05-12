# == Schema Information
#
# Table name: topics
#
#  id         :bigint           not null, primary key
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Topic < ApplicationRecord
  has_many  :messages, dependent: :destroy

  validates :title, presence: true
end
