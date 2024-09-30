# Paw Pilot 🐾✈️

**Paw Pilot** is a comprehensive management application for a fictional dog walking company. Designed with efficiency and real-time coordination in mind, Paw Pilot allows dog walkers and managers to seamlessly handle daily operations, scheduling, and dog assignments. The application features advanced geolocation clustering and AI optimization to streamline routes and improve service delivery.

## Table of Contents

- [Features](#features)
- [Tech Stack](#tech-stack)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Database Setup](#database-setup)
- [Running the Application](#running-the-application)
- [Running Tests](#running-tests)
- [Usage](#usage)
  - [Logging In](#logging-in)
  - [Dog Walker Dashboard](#dog-walker-dashboard)
  - [Manager Dashboard](#manager-dashboard)
- [Seed Data](#seed-data)
- [Advanced Features](#advanced-features)
  - [Geolocation and Route Optimization](#geolocation-and-route-optimization)
  - [AI-Powered Shift Optimization](#ai-powered-shift-optimization)
- [Future Enhancements](#future-enhancements)
- [Notes](#notes)
- [Getting Help](#getting-help)

---

## Features

- **Dog Walkers:**
  - View lists of assigned dogs for morning and afternoon shifts each day.
  - Update the status of each dog in real-time:
    - Home (Not picked up yet)
    - In van on the way to field
    - At field
    - On way home
    - Home (Dropped off)

- **Managers:**
  - View all dog walkers' schedules.
  - Assign, remove, or move dogs between walkers using an intuitive drag-and-drop interface.
  - Visualize dog locations and optimize routes using an interactive map.

- **Additional:**
  - **Geolocation Tracking:**
    - Dogs are geolocated based on their pickup addresses.
    - Advanced clustering algorithms optimize pickup routes.
  - **AI-Powered Optimization:**
    - Integrates with OpenAI's GPT to intelligently group dogs and assign them to walkers.
    - Enhances efficiency by minimizing travel distances and balancing workloads.

---

## Tech Stack

- **Backend:** Ruby on Rails 7
- **Frontend:** Hotwire (Turbo & Stimulus), Tailwind CSS, Flowbite components
- **Database:** PostgreSQL
- **Authentication:** Devise
- **Authorization:** Pundit
- **Testing:** RSpec, FactoryBot
- **Geolocation & Mapping:** Google Maps API, K-Means Clustering
- **AI Integration:** OpenAI GPT API

---

## Prerequisites

- **Ruby:** Version 3.0.0 or higher
- **Rails:** Version 7.0.0 or higher
- **PostgreSQL:** Version 12 or higher
- **Node.js and Yarn:** For managing JavaScript dependencies
- **Git:** For version control
- **API Keys:**
  - **Google Maps API Key:** For geolocation and mapping features
  - **OpenAI API Key:** For AI-powered optimization (optional)

---

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

---

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

   - **Users:**
     - Manager
     - Dog Walkers
     - Dog Owners (customers)
   - **Dogs:**
     - Associated with Dog Owners
   - **Vans:**
     - 10 vans with a capacity of 12 dogs each
   - **Shifts:**
     - Morning and afternoon shifts for past, present, and future days
   - **Assignments:**
     - Dog Walkers assigned to shifts and vans
   - **Dog Schedules:**
     - Dogs scheduled for specific days and shifts based on their owner's preferences

---

## Running the Application

Start the Rails server:

```bash
rails server
```

Visit the application at [http://localhost:3000](http://localhost:3000).

---

## Running Tests

Run the test suite using RSpec:

```bash
bundle exec rspec
```

---

## Usage

### Logging In

- **Manager Account:**

  - **Email:** `manager@example.com`
  - **Password:** `password`

- **Dog Walker Accounts:**

  - **Email:** `walker1@example.com` to `walker10@example.com`
  - **Password:** `password`

> **Note:** Currently, dog owners cannot log in to the system.

---

### Dog Walker Dashboard

- **Shift Overview:**
  - View assigned shifts for the day, categorized into morning and afternoon.
  - See a list of dogs assigned for each shift.

- **Status Updates:**
  - Update the status of each dog in real-time as you progress through your route.
  - Status changes are reflected instantly using Hotwire's Turbo Streams.

---

### Manager Dashboard

- **Schedule Management:**
  - View all dog walkers and their current assignments.
  - Drag and drop dogs between walkers to reassign them effortlessly.

- **Route Optimization:**
  - Utilize the interactive map to visualize the locations of all dogs and vans.
  - Leverage geolocation clustering to optimize pickup routes.

- **Advanced Features:**
  - Access AI-powered tools to optimize shifts and assignments.
  - Monitor overall operational efficiency.

---

## Seed Data

The seed data is designed to provide a realistic simulation of the company's operations.

- **Users:**
  - **Manager:**
    - Email: `manager@example.com`
    - Password: `password`
  - **Dog Walkers:**
    - Emails: `walker1@example.com` to `walker10@example.com`
    - Password: `password`
  - **Dog Owners:**
    - 50 customers with randomly generated emails and names.

- **Dogs:**
  - Each customer owns 1 to 3 dogs.
  - Dogs have realistic names, breeds, ages, and pickup addresses within the Atlanta area.
  - Dogs are geolocated using latitude and longitude coordinates.

- **Dog Subscriptions:**
  - Each dog has a subscription indicating the days they are scheduled (Monday to Friday) and the length of the day (`full`, `morning`, or `afternoon`).
  - Subscriptions are randomly generated to simulate varied customer preferences.

- **Shifts:**
  - Morning and afternoon shifts are created for past, present, and future days.
  - Shifts are assigned to dog walkers and vans.

- **Assignments:**
  - Dog walkers are assigned to shifts and vans.
  - Dogs are assigned to shifts based on their subscriptions and day lengths.

- **Dog Schedules:**
  - Reflect the assignments of dogs to walkers for specific shifts.
  - Include the status of each dog, which varies based on the shift date.

---

## Advanced Features

### Geolocation and Route Optimization

- **Clustering Algorithm:**
  - Implements K-Means clustering to group dogs based on their pickup locations.
  - Ensures each walker has a route optimized for minimal travel distance.
  - Adheres to the van capacity limit of 12 dogs per walker.

- **Interactive Map:**
  - Visualizes the locations of dogs and vans.
  - Allows managers to see real-time updates of dog statuses and walker positions.

- **GeoService Class:**
  - Handles the optimization logic using the `kmeans-clusterer` gem.
  - Adjusts clusters to respect capacity constraints.
  - Assigns dogs to walkers based on optimized clusters.

### AI-Powered Shift Optimization

- **OpenAI Integration:**
  - Uses OpenAI's GPT models to intelligently group dogs into batches.
  - Enhances route optimization beyond traditional algorithms.

- **AiServices::OptimizeShiftService:**
  - Defines a service class that interacts with the OpenAI API.
  - Provides a prompt that instructs the AI to group dogs based on geolocation data.
  - Assigns the AI-generated batches of dogs to walkers.

- **Benefits:**
  - Further reduces travel distances and time.
  - Balances workloads among walkers.
  - Demonstrates innovative use of AI in operational logistics.

---

## Future Enhancements

- **Enhanced Mapping Features:**
  - Improve the admin map interface for better usability.
  - Include features like route planning and real-time traffic updates.

- **Customer Portal:**
  - Develop an interface for dog owners to log in.
  - Allow customers to view their dog's status and manage subscriptions.

- **AI-Driven Insights:**
  - Expand AI integration to provide predictive analytics.
  - Forecast operational challenges and suggest proactive solutions.

- **Mobile Application:**
  - Create a mobile app for dog walkers for on-the-go access.
  - Include features like push notifications and GPS tracking.

---

## Notes

- **Authentication:**
  - Devise handles user authentication.
  - Users have roles (`manager`, `dog_walker`, `dog_owner`) that determine access levels.

- **Authorization:**
  - Pundit manages user permissions and access control.

- **Real-time Updates:**
  - Hotwire's Turbo Streams enable live updates without full page reloads.
  - Dog statuses and assignments update instantly across all connected clients.

- **Design and UI:**
  - Tailwind CSS and Flowbite components provide a modern and responsive design.
  - The interface is optimized for both desktop and mobile browsers.

- **Testing:**
  - RSpec is configured for comprehensive unit and feature tests.
  - FactoryBot sets up factories for consistent test data.

---

## Getting Help

If you encounter any issues or have questions, feel free to reach out via email or create an issue in the repository.

- **Email:** [your-email@example.com](mailto:your-email@example.com)
- **GitHub Issues:** [https://github.com/yourusername/paw-pilot/issues](https://github.com/yourusername/paw-pilot/issues)

---

**Thank you for exploring Paw Pilot! We hope this application demonstrates thoughtful design and provides a robust foundation for managing a dynamic dog walking service.**

---

## Appendix

### Key Classes and Services

- **GeoService:**
  - Located at `app/services/geo_service.rb`.
  - Handles the geolocation clustering logic.
  - Uses the `kmeans-clusterer` gem for K-Means clustering.

- **AiServices::OptimizeShiftService:**
  - Located at `app/services/ai_services/optimize_shift_service.rb`.
  - Interacts with the OpenAI API to optimize dog assignments.
  - Parses AI-generated recommendations and applies them to shift scheduling.

### Environment Variables

- **Google Maps API Key:**
  - Set `GOOGLE_MAPS_API_KEY` in your environment variables.
  - Required for geolocation and mapping features.

- **OpenAI API Key:**
  - Set `OPENAI_API_KEY` in your environment variables.
  - Required for AI-powered optimization features.

### Additional Setup for AI Features

1. **Install the OpenAI Gem**

   Ensure the `openai` gem is included in your `Gemfile`:

   ```ruby
   gem 'openai'
   ```

   Run `bundle install` to install the gem.

2. **Configure OpenAI Client**

   Create an initializer at `config/initializers/openai.rb`:

   ```ruby
   OpenAI.configure do |config|
     config.access_token = ENV.fetch('OPENAI_API_KEY')
   end
   ```

3. **Set Up Error Monitoring (Optional)**

   If you use error monitoring tools like Bugsnag, configure them accordingly in your services.