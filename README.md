##### Prerequisites

The setups steps expect following tools installed on the system.

- Github
- Ruby [2.7.2](https://github.com/VincentWijaya/simple-loyalty-app/blob/master/.ruby-version#L1)
- Rails [7.0.2](https://github.com/VincentWijaya/simple-loyalty-app/blob/master/Gemfile#L7)

##### 1. Check out the repository

```bash
git clone https://github.com/VincentWijaya/simple-loyalty-app.git
```

##### 2. Create and setup the database

Run the following commands to create and setup the database.

```ruby
bundle exec rake db:create
bundle exec rake db:setup
```

##### 3. Start the Rails server

You can start the rails server using the command given below.

```ruby
rails s
```