# HitsCounter

This is a simple Rails Gem that counts visits per day to certain URLs that you can define in the Gem's config file.

tested with Ruby 2.3.4, Rails 5.1


## Installation

clone this repo to your Rails App's root directory

`git clone https://github.com/omar84/hits_counter.git`

Add this line to your application's Gemfile:

```ruby
gem "hits_counter", :path => "hits_counter"
```
run the following:

    $ bundle
    $ bundle exec rails generate hits_counter:install
    $ bundle exec rake db:migrate

edit `config/initializers/hits_counter.rb` and change its config values to fit your needs

add the following lines to `app/controllers/application_controller.rb`:
```ruby
  before_action :examine_url

  helper_method :hc_logged_in?

  def hc_logged_in?
    not session[:hc_username].blank?
  end

  private

  def examine_url
    require 'hits_counter'

    HitsCounter.match_url(request.original_fullpath)
  end
```

if you have a catch-all route defined at the end of your `config/routes.rb`, insert these routes in the line before:
```ruby
  match 'hits_login' => 'hits_counter/hc_sessions#login', :via => [:post]
  match 'hits_logout' => 'hits_counter/hc_sessions#logout', :via => [:get]
  match 'hits_report' => 'hits_counter/hc_matching_hits#index', :via => [:get]
```

```ruby
### catch-all route example:
  match '*path' => 'welcome#index', via: [:get]
```

restart your app


## Usage

visit some URLs that match your config rules, and some that don't, to populate the database with some data

go to `http://YOUR-APP-URL/hits_report`

enter login information matching the username/password in the initializer config file that you changed earlier

you will get access to the summary of the hits counter, as well as be able to export it to csv.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).


## Code of Conduct

Everyone interacting in the HitsCounter project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/hits_counter/blob/master/CODE_OF_CONDUCT.md).
