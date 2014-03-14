CarrierWave.configure do |config|
  if Rails.env.production? || Rails.env.staging?

    config.storage = :fog

    config.fog_credentials = {
      :provider               => 'AWS',
      :aws_access_key_id      => Figaro.env.aws_access_key_id, 
      :aws_secret_access_key  => Figaro.env.aws_secret_access_key 
    }

    config.fog_directory  = Figaro.env.fog_directory

    config.fog_public     = true
    config.fog_attributes = {'Cache-Control' => 'max-age=315576000'}

  else
    config.storage = :file
  end
end