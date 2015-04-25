class Build < ActiveRecord::Base
  belongs_to :repo
  has_many :violations, dependent: :destroy
  has_many :file_reviews, dependent: :destroy

  before_create :generate_uuid

  validates :repo, presence: true

  def status
    if violations.any?
      'failed'
    else
      'passed'
    end
  end

  private

  def generate_uuid
    self.uuid = SecureRandom.uuid
  end
end
