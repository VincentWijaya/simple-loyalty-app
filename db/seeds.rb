# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

Tier.create([
              {
                name: 'Bronze',
                minSpent: 0
              },
              {
                name: 'Silver',
                minSpent: 100
              },
              {
                name: 'Gold',
                minSpent: 500
              }
            ])
