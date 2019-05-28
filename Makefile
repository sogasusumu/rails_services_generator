# https://easyramble.com/create-rails-plugin-gem.html
link_dummy:
	cd spec/dummy && ln -s ../../spec

spec_generate:
	cd spec/dummy && bin/rails generate rspec:install

rm_dummy_spec:
	rm spec/dummy/spec

run_rspec:
	bundle exec rspec spec

run_generator:
	spec/dummy/bin/rails g controller_with_services arg0 index show create update delete destroy -m m1 m2 m3

gen_interactor:
	spec/dummy/bin/rails g interactor cont#index

del_interactor:
	spec/dummy/bin/rails d interactor cont#index

delete_generator:
	spec/dummy/bin/rails d controller_with_services arg0

template_copy:
	cd spec/dummy && bundle exec rails app:templates:copy
