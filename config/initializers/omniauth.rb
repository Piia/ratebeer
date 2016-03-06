Rails.application.config.middleware.use OmniAuth::Builder do
    provider :github, ENV['141f14babec474342874'], ENV['836ff733bcfda8adb7240b1d9990e94ad3a0e6ac']
end