# https://easyramble.com/create-rails-plugin-gem.html
link_dummy:
	cd spec/dummy && ln -s ../../spec

spec_generate:
	cd spec/dummy && bin/rails generate rspec:install

rm_dummy_spec:
	rm spec/dummy/spec

run_rspec:
	bundle exec rspec spec
