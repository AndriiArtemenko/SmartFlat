	ActionMailer::Base.delivery_method = :smtp
	ActionMailer::Base.raise_delivery_errors = true
	ActionMailer::Base.smtp_settings = {
		address:              'smtp.gmail.com',
		port:                 587,
		domain:               'gmail.com',
		user_name:            'smartflat48@gmail.com',
		password:             'G5dkbw6ggsq',
		openssl_verify_mode:  'none',
		authentication:       :plain,
		enable_starttls_auto: true
	}