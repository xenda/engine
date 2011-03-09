CarrierWave.configure do |config|

  case Rails.env.to_sym

  when :development
    config.storage = :file
    config.root = File.join(Rails.root, 'public')

  when :production
    config.storage = :s3
    config.s3_access_key_id = ENV['S3_KEY_ID']
    config.s3_secret_access_key = ENV['S3_SECRET_KEY']
    config.s3_bucket = ENV['S3_BUCKET']

    puts ENV['S3_KEY_ID']
    puts ENV['S3_SECRET_KEY']
    puts ENV['S3_BUCKET']                   
    config.s3_access_policy = :public_read
  end

end
