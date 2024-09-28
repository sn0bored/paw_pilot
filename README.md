# Paw Pilot 🐾✈️

**Paw Pilot** is a fictional dog walking company application designed to manage dog walkers, their schedules, and the dogs they care for. Built with a focus on efficiency and real-time updates, Paw Pilot allows dog walkers and managers to seamlessly coordinate daily operations.

## Table of Contents

- [Features](#features)
- [Tech Stack](#tech-stack)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Database Setup](#database-setup)
- [Running the Application](#running-the-application)
- [Running Tests](#running-tests)
- [Usage](#usage)
- [Seed Data](#seed-data)
- [Notes](#notes)

## Features

- **Dog Walkers:**
  - View list of assigned dogs for morning and afternoon shifts.
  - Update the status of each dog in real-time:
    - Home (Not picked up yet)
    - In van on the way to field
    - At field
    - On way home
    - Home (Dropped off)

- **Managers:**
  - View all dog walkers' schedules.
  - Assign, remove, or move dogs between walkers.

- **Additional:**
  - Geolocation tracking for dogs via collars.
  - Interactive map to display the location of vans and dogs.

## Tech Stack

- **Backend:** Ruby on Rails 7
- **Frontend:** Hotwire (Turbo & Stimulus), Flowbite (Tailwind CSS components)
- **Database:** PostgreSQL
- **Authentication:** Devise
- **Authorization:** Pundit
- **Testing:** RSpec
- **Maps & Geolocation:** Google Maps API (optional)

## Prerequisites

- **Ruby:** Version 3.0.0 or higher
- **Rails:** Version 7.0.0 or higher
- **PostgreSQL:** Version 12 or higher
- **Node.js and Yarn:** For managing JavaScript dependencies
- **Git:** For version control

## Installation

1. **Clone the Repository**

   ```bash
   git clone https://github.com/yourusername/paw-pilot.git
   cd paw-pilot
   ```

2. **Install Ruby Gems**

   Install the required gems using Bundler:

   ```bash
   bundle install
   ```

3. **Install JavaScript Packages**

   Install JavaScript dependencies using Yarn:

   ```bash
   yarn install
   ```

## Database Setup

1. **Configure Database**

   Update the `config/database.yml` file with your PostgreSQL credentials:

   ```yaml
   default: &default
     adapter: postgresql
     encoding: unicode
     username: YOUR_POSTGRES_USERNAME
     password: YOUR_POSTGRES_PASSWORD
     host: localhost

   development:
     <<: *default
     database: paw_pilot_development

   test:
     <<: *default
     database: paw_pilot_test

   production:
     <<: *default
     database: paw_pilot_production
     username: paw_pilot
     password: <%= ENV['PAW_PILOT_DATABASE_PASSWORD'] %>
   ```

2. **Create and Migrate Database**

   ```bash
   rails db:create
   rails db:migrate
   ```

3. **Seeding the Database**

   Populate the database with seed data:

   ```bash
   rails db:seed
   ```

   This will create:

   - Admin user (manager)
   - Dog walkers
   - Dog owners
   - Dogs
   - Vans
   - Shifts
   - Assignments and schedules

## Running the Application

Start the Rails server:

```bash
rails server
```

Visit the application at [http://localhost:3000](http://localhost:3000).

## Running Tests

Run the test suite using RSpec:

```bash
bundle exec rspec
```

## Usage

### Logging In

- **Manager:**
  - Email: `manager@example.com`
  - Password: `password`

- **Dog Walker:**
  - Email: `walker1@example.com`
  - Password: `password`

### Dog Walker Dashboard

- View assigned shifts for the day.
- Update the status of each dog in your van.
- Real-time updates via Hotwire.

### Manager Dashboard

- Access through the manager account.
- View all dog walkers and their schedules.
- Assign or reassign dogs to different walkers.
- Manage vans and shift assignments.

## Seed Data

The seed file includes:

- **Users:**
  - Managers
  - Dog Walkers
  - Dog Owners

- **Dogs:**
  - Associated with Dog Owners

- **Vans:**
  - 10 vans with a capacity of 12 dogs each

- **Shifts:**
  - Morning and afternoon shifts for the current week

- **Assignments:**
  - Dog Walkers assigned to shifts and vans

- **Dog Schedules:**
  - Dogs scheduled for specific days and shifts based on their owner's preferences

## Notes

- **Authentication:**
  - Devise is used for user authentication.
  - Roles are managed via a `role` attribute on the `User` model.

- **Authorization:**
  - Pundit is used for managing user permissions.

- **Real-time Features:**
  - Hotwire (Turbo Streams) is used for live updates without page reloads.

- **Design:**
  - Flowbite components are utilized for a clean and responsive UI.
  - Tailwind CSS is the underlying CSS framework.

- **Testing:**
  - RSpec is configured for unit and feature tests.
  - Factories are set up using FactoryBot.

- **Geolocation (Optional):**
  - If you wish to enable geolocation features:
    - Obtain a Google Maps API key.
    - Configure the `GOOGLE_MAPS_API_KEY` environment variable.
    - Update the `Collar` model and views accordingly.

## Getting Help

If you encounter any issues or have questions, feel free to reach out via email or create an issue in the repository.

---

**Thank you for trying out Paw Pilot!**