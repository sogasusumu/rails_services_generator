# RailsServicesGenerator
本プラグインをInstallすると、
Controller及び、以下のサービスを生成するジェネレータが追加されます。
- interactor
- repository
- responder

## Usage
```bash

# rails g controller_with_services ControllerName Actions -m using Modles
# 詳細は、`rails g controller_with_services`コマンドでご確認ください。
rails g controller_with_services User index create show update -m User Account Email

```

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'rails_services_generator', git: 'https://github.com/sogasusumu/rails_services_generator.git'
```

And then execute:
```bash
$ bundle
```
