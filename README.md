Padrino-Relative
===============
This is a simple gem, extracted from [this pull request](https://github.com/padrino/padrino-framework/pull/955). It monkey patches some Padrino class to work, so there's no need for some `helper` or `register` method call. Having `helper` or `register` support would be nice, though. Nicer than simply monkey patching Padrino, anyway.

Installation
-----
Just add the following to your `Gemfile`:

    gem 'padrino-relative'

Then just `bundle install`. Done.

Usage
-----
Try this without the gem installed:

    MyApp.controllers :users do
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

Install the gem, `bundle install`, and `padrino rake routes`. We get the following:

    # $ padrino rake routes
    => Executing Rake routes ...

    Application: MyApp
    URL                     REQUEST  PATH
    (:users, :sign, :up)      GET    /sign_up
    (:users, :sign, :in)      GET    /sign_in
    (:users, :list)           GET    /users
    (:users, :show)           GET    /users/:id

That's it. It makes routes nice and relative, given they don't start with a `/`. Makes the code more DRY.
