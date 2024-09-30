# db/seeds.rb

require 'faker'

# At the top of the file, after the require statements
DOG_NAMES = [
  "Max", "Bella", "Charlie", "Lucy", "Cooper", "Luna", "Milo", "Daisy",
  "Rocky", "Molly", "Bailey", "Sadie", "Buddy", "Lola", "Jack", "Stella",
  "Oliver", "Chloe", "Leo", "Penny", "Duke", "Zoe", "Bear", "Rosie",
  "Tucker", "Ruby", "Oscar", "Lily", "Bentley", "Maggie", "Toby", "Sophie",
  "Zeus", "Nala", "Winston", "Gracie", "Finn", "Coco", "Koda", "Riley",
  "Louie", "Roxy", "Archie", "Millie", "Ollie", "Frankie", "Thor", "Willow",
  "Loki", "Pepper", "Gus", "Harley", "Sam", "Nova", "Murphy", "Layla",
  "Moose", "Piper", "Bruno", "Athena", "Dexter", "Ellie", "Diesel", "Hazel"
]

# Clear existing data
DogSchedule.delete_all
Assignment.delete_all
Shift.delete_all
DogSubscription.delete_all
Dog.delete_all
Van.delete_all
User.delete_all

# Create a manager (who is also a dog walker)
manager = User.create!(
  email: 'manager@example.com',
  password: 'password',
  role: :manager,
  name: Faker::Name.name
)

# Create 10 dog walkers (excluding the manager)
10.times do |i|
  User.create!(
    email: "walker#{i+1}@example.com",
    password: 'password',
    role: :dog_walker,
    name: Faker::Name.name
  )
end

# Create 10 vans
10.times do |i|
  Van.create!(
    name: "Van ##{i+1}",
    capacity: 12
  )
end

# Create customers and their dogs
customer_count = 150  # Increased from 80
dog_count = 0

customer_count.times do
  customer = User.create!(
    email: Faker::Internet.unique.email,
    password: 'password',
    role: :dog_owner,
    name: Faker::Name.name
  )

  # Each customer owns 1 to 3 dogs
  rand(1..3).times do
    latitude = Faker::Number.between(from: 40.5774, to: 40.9176)
    longitude = Faker::Number.between(from: -74.15, to: -73.7004)

    dog = Dog.create!(
      name: DOG_NAMES.sample,
      breed: Faker::Creature::Dog.breed,
      age: rand(1..10),
      owner: customer,
      street_address: Faker::Address.street_address,
      city: Faker::Address.city,
      state: Faker::Address.state_abbr,
      zip_code: Faker::Address.zip_code,
      latitude: latitude,
      longitude: longitude
    )

    # Create a DogSubscription with random days and day_length
    DogSubscription.create!(
      dog: dog,
      monday: [true, false].sample,
      tuesday: [true, false].sample,
      wednesday: [true, false].sample,
      thursday: [true, false].sample,
      friday: [true, false].sample,
      day_length: DogSubscription.day_lengths.keys.sample  # Randomly assign day_length
    )

    dog_count += 1
  end
end

Faker::UniqueGenerator.clear

puts "Created #{customer_count} customers with #{dog_count} dogs."

# Create Shifts for Past, Present, and Future Days

require 'date'

today = Date.today
dates = [
  today - 2, # Two days ago (Past)
  today - 1, # Yesterday (Past)
  today,     # Today (Present)
  today + 1, # Tomorrow (Future)
  today + 2  # Day after tomorrow (Future)
]

shifts = []

dates.each do |date|
  [:morning, :afternoon].each do |time_of_day|
    shift = Shift.create!(
      date: date,
      time_of_day: Shift.time_of_days[time_of_day]
    )
    shifts << shift
  end
end

puts "Created shifts for past, present, and future days."

# Assign walkers to shifts and vans (manager included)
walkers = User.where(role: [:dog_walker, :manager]).to_a
vans = Van.all.to_a

shifts.each do |shift|
  walkers.each_with_index do |walker, index|
    Assignment.create!(
      user: walker,
      shift: shift,
      van: vans[index % vans.size]
    )
  end
end

puts "Assigned walkers to shifts and vans."

# Assign dogs to shifts based on their subscriptions and create DogSchedules
dogs = Dog.all.to_a

shifts.each do |shift|
  # Determine the day of the week for the shift
  day_symbol = case shift.date.wday
               when 1 then :monday
               when 2 then :tuesday
               when 3 then :wednesday
               when 4 then :thursday
               when 5 then :friday
               else
                 next # Skip weekends
               end

  # Determine the time of day for the shift
  shift_time = shift.time_of_day  # 'morning' or 'afternoon'

  # Select dogs subscribed for this day and time
  subscribed_dogs = Dog.joins(:dog_subscription).where(
    dog_subscriptions: { day_symbol => true }
  ).where(
    dog_subscriptions: { day_length: ['full', shift_time] }
  ).distinct.to_a

  # Shuffle dogs to randomize assignment
  subscribed_dogs.shuffle!

  # Get assignments (walkers) for this shift
  walker_assignments = Assignment.where(shift: shift).to_a

  # Assign dogs to walkers and create DogSchedules
  dogs_per_walker = Hash.new(0)
  max_dogs_per_walker = 12

  subscribed_dogs.each do |dog|
    # Find a walker who hasn't reached max capacity
    assignment = walker_assignments.find do |a|
      dogs_per_walker[a.user_id] < max_dogs_per_walker
    end

    break unless assignment  # No available walkers

    # Set status based on shift date
    if shift.date < today
      status = 'dropped_off'
    elsif shift.date == today
      status = DogSchedule.statuses.keys.sample
    else
      status = 'home'
    end

    # Assign the dog to the walker
    DogSchedule.create!(
      dog: dog,
      shift: shift,
      status: status,
      walker: assignment.user
    )

    # Increment the count
    dogs_per_walker[assignment.user_id] += 1
  end

  # Output the number of dogs assigned to the shift
  total_dogs_assigned = dogs_per_walker.values.sum
  puts "Shift on #{shift.date} (#{shift.time_of_day}): Assigned #{total_dogs_assigned} dogs"
end

puts "Assigned dogs to shifts and created DogSchedules with appropriate statuses."

# Create a waitlist (additional customers and dogs beyond capacity)
waitlist_customers = 50  # Increased from 20
waitlist_dog_count = 0

waitlist_customers.times do
  customer = User.create!(
    email: Faker::Internet.unique.email,
    password: 'password',
    role: :dog_owner,
    name: Faker::Name.name
  )

  # Each customer owns 1 to 3 dogs
  rand(1..3).times do
    latitude = Faker::Number.between(from: 40.5774, to: 40.9176)
    longitude = Faker::Number.between(from: -74.15, to: -73.7004)

    dog = Dog.create!(
      name: DOG_NAMES.sample,
      breed: Faker::Creature::Dog.breed,
      age: rand(1..10),
      owner: customer,
      street_address: Faker::Address.street_address,
      city: Faker::Address.city,
      state: Faker::Address.state_abbr,
      zip_code: Faker::Address.zip_code,
      latitude: latitude,
      longitude: longitude
    )

    # Create a DogSubscription with random days and day_length
    DogSubscription.create!(
      dog: dog,
      monday: [true, false].sample,
      tuesday: [true, false].sample,
      wednesday: [true, false].sample,
      thursday: [true, false].sample,
      friday: [true, false].sample,
      day_length: DogSubscription.day_lengths.keys.sample
    )

    waitlist_dog_count += 1
  end
end

Faker::UniqueGenerator.clear

puts "Created waitlist with #{waitlist_customers} customers and #{waitlist_dog_count} dogs."

puts "Seeding completed."
