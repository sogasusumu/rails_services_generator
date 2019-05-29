# https://easyramble.com/create-rails-plugin-gem.html
link_dummy:
	cd spec/dummy && ln -s ../../spec

spec_generate:
	cd spec/dummy && bin/rails generate rspec:install

rm_dummy_spec:
	rm spec/dummy/spec

run_rspec:
	bundle exec rspec spec

template_copy:
	cd spec/dummy && bundle exec rails app:templates:copy

run_generator:
	spec/dummy/bin/rails g controller_with_services controller_name index show create update delete destroy invalid_action -m model_one model_two model_three

delete_generator:
	spec/dummy/bin/rails d controller_with_services controller_name
