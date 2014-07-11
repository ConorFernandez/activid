class OrderFile < ActiveRecord::Base
  belongs_to :order

  after_destroy :remove_from_s3

  protected

  def remove_from_s3
    s3 = AWS.s3
    bucket = s3.buckets[ENV['S3_BUCKET']]
    s3_object = bucket.objects[uploaded_filename]

    s3_object.delete if s3_object.exists?
  end
end
