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

#### Updating tier
To perform update tier for all user you can run ```Customer.update_tier``` in rails console. Beside that, I already create a cron that will run once a year at January 1th 00:01pm

#### Web page URL
1. Get customer detail http://localhost:3000/customers/123
2. Get customer order history http://localhost:3000/customers/123/order_history

#### API List
##### 1. Create Order
```curl
curl --location 'localhost:3000/orders' \
--header 'Content-Type: application/json' \
--data '{
    "customerId": "123",
    "customerName": "Taro Suzuki",
    "orderId": "T123",
    "totalInCents": 5000,
    "date": "2022-12-04T05:29:59.850Z"
}'
```
##### 2. Get customer detail
```curl
curl --location 'localhost:3000/customers/123.json'
```
##### 3. Get all customer order
```curl
curl --location 'localhost:3000/orders.json?customer_id=123&page=1&per_page=10'
```