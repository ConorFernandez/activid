FactoryGirl.define do
  factory :video_length do

  end

  factory :two_minute_video, parent: :video_length do
    name '1:30-2 Minutes'
    cost 95.0
    enabled true
  end

  factory :three_minute_video, parent: :video_length do
    name '2-3 Minutes'
    cost 146.0
    enabled true
  end

  factory :four_minute_video, parent: :video_length do
    name '3-4 Minutes'
    cost 185.00
    enabled true
  end
end