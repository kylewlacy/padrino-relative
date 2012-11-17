Padrino-Relative
===============
This is a simple gem, extracted from [this pull request](https://github.com/padrino/padrino-framework/pull/955). Uses `register`, so you can easily toggle it on a per-app basis. Nice and simple.

Installation
-----
Add the following to your `Gemfile`:

    gem 'padrino-relative'

`bundle install`, and add the following to your `app/app.rb` file:

    register Padrino::Relative

Done.

Usage
-----
Try this without the gem installed:

    MyApp.controller :users do
        get :sign_up, '/sign_up' do
            'sign up page'
        end

        get :sign_in, '/sign_in' do
            'sign in page'
        end

        get :list, '/' do
            'listing all users'
        end

        get :show, ':id' do
            "showing user with id #{params[:id]}"
        end
    end

Intuition will tell that running `padrino rake routes` would show us that Padrino is intelligent. We don't see that:

    # $ padrino rake routes
    => Executing Rake routes ...

    Application: MyApp
    URL                     REQUEST  PATH
    (:users, :sign, :up)      GET    /sign_up
    (:users, :sign, :in)      GET    /sign_in
    (:users, :list)           GET    /users
    (:users, :show)           GET    /:id

I want the `:list` route to end up on `/users`, so I change that block to the following:

    get :list, :index do
        'listing all users'
    end

Install and setup the gem, run `padrino rake routes` again, and I get the following:

    # $ padrino rake routes
    => Executing Rake routes ...

    Application: MyApp
    URL                     REQUEST  PATH
    (:users, :sign, :up)      GET    /sign_up
    (:users, :sign, :in)      GET    /sign_in
    (:users, :list)           GET    /users
    (:users, :show)           GET    /users/:id

That's it. It makes routes nice and relative, given they don't start with a `/`. Makes the code more DRY.
