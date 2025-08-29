# README

I get zero credit for this pattern/setup. This is based off this article https://boringrails.com/articles/self-updating-components/

## Setup
```
# Install deps
bundle install

# Create the database
rails db:create

# Run migrations
rails db:migrate

# Seed the database (if seeds exist)
rails db:seed

# Start it up
rails server

# Might need to tailwind watch for CSS changes to show
rails tailwindcss:watch
```
