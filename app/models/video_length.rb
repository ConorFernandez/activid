class VideoLength < ActiveRecord::Base

  scope :enabled, -> { where(enabled: true) }
end
