class Course < ApplicationRecord
  extend FriendlyId

  serialize :you_learn, Array
  serialize :you_build, Array

  has_many :sections
  has_many :lessons, through: :sections

  validates_uniqueness_of :position

  friendly_id :title, use: [:slugged, :finders]

  def percent_completed_by(user)
    100 * (1.0 - uncompleted_lessons_in_course(user) / lessons.count.to_f)
  end

  def completed_by?(user)
    percent_completed_by(user) == 100
  end

  def lessons_in_course
    lessons.order(position: :asc)
  end

  def lessons_count
    lessons.count
  end

  private

  def uncompleted_lessons_in_course(user)
    (lessons - user.completed_lessons).count.to_f
  end
end
