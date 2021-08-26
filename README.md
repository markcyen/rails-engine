# Rails Engine

## Project Description
This is a solo project that includes a ReSTful API exposing merchants, items, and aggregate revenue data for a mock retail e-commerce site. There were nine ReSTful  and six non-ReSTful API endpoints exposed in this project. This Rails application utilized the gem `jsonapi-serializer` to serialize all data endpoints.

### Versions
 - Ruby 2.7.2
 - Rails 5.2.5

### Setup
````
$ git clone git@github.com:markcyen/rails-engine.git
$ cd rails-engine
$ bundle install
$ rails db:{drop,create,migrate,seed}
$ rails db:schema:dump
````
 - run `rails c` to jump into your rails console
 - run `Customer.first` to see if the first customer object appears
````
#<Customer id: 1, first_name: "Joey", last_name: "Ondricka", created_at: "2012-03-27 14:54:09", updated_at: "2012-03-27 14:54:09">
````
 - run `Customer.last` to see if the last customer object appears
````
#<Customer id: 1000, first_name: "Shawn", last_name: "Langworth", created_at: "2012-03-27 14:58:15", updated_at: "2012-03-27 14:58:15">
````

### Testing

 - Test Driven Development approach
 - FactoryBot and Faker gems were used to create mock merchants and items data
 - SimpleCov was used to identify total test coverage
 - To run test, type in the following in your terminal
````
$ bundle exec rspec
````

### Example of Endpoints

#### Getting all merchants example:

`GET /merchants`

Response:
````
{
    "data": [
        {
            "id": "1",
            "type": "merchant",
            "attributes": {
                "name": "Schroeder-Jerde"
            }
        },
        {
            "id": "2",
            "type": "merchant",
            "attributes": {
                "name": "Klein, Rempel and Jones"
            }
        },
        ....
    ]
}
````

#### Get specific item data:

`GET /items/id`

Response:
````
{
    "data": {
        "id": "179",
        "type": "item",
        "attributes": {
            "name": "Item Qui Veritatis",
            "description": "Totam labore quia harum dicta eum consequatur qui. Corporis inventore consequatur. Illum facilis tempora nihil placeat rerum sint est. Placeat ut aut. Eligendi perspiciatis unde eum sapiente velit.",
            "unit_price": 906.17,
            "merchant_id": 9
        }
    }
}
````

#### Find all merchants endpoint (Non-ReSTful)

`GET /api/v1/merchants/find_all?name=ring`

Response:
````
{
  "data": [
    {
      "id": "4",
      "type": "merchant",
      "attributes": {
        "name": "Ring World"
      }
    },
    {
      "id": "1",
      "type": "merchant",
      "attributes": {
        "name": "Turing School"
      }
    }
  ]
}
````

#### Getting merchants with the most revenue (Non-ReSTful)

`GET /api/v1/revenue/merchants?quantity=2`

Response:
````
{
  "data": [
    {
      "id": "1",
      "type": "merchant_name_revenue",
      "attributes": {
        "name": "Turing School",
        "revenue": 512.256128
      }
    },
    {
      "id": "4",
      "type": "merchant_name_revenue",
      "attributes": {
        "name": "Ring World",
        "revenue": 245.130001
      }
    }
  ]
}
````
