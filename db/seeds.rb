# Clear existing data
Van.destroy_all
Dog.destroy_all
User.destroy_all
Shift.destroy_all
DogSchedule.destroy_all
Assignment.destroy_all

# Create an admin (who is also a manager and dog walker)
admin = User.create!(
  email: 'admin@dogwalking.com',
  password: 'password',
  role: :manager,
  name: 'Admin Manager'
)

# Create 10 dog walkers (including the admin as the manager walker)
walkers = [admin] + 9.times.map do |i|
  User.create!(
    email: "walker#{i + 1}@dogwalking.com",
    password: 'password',
    role: :dog_walker,
    name: "Walker #{i + 1}"
  )
end

# Create 10 vans
vans = 10.times.map do |i|
  Van.create!(name: "Van #{i + 1}", capacity: 12)
end

# Create 120 dogs with owners and subscriptions (varied days selection)
dogs = 120.times.map do |i|
  owner = User.create!(
    email: "owner#{i + 1}@dogwalking.com",
    password: 'password',
    role: :dog_owner,
    name: "Owner #{i + 1}"
  )

  dog = Dog.create!(
    name: "Dog #{i + 1}",
    breed: %w[Labrador Poodle Beagle Bulldog Shih\ Tzu].sample,
    age: rand(1..10),
    user: owner
  )

  # Randomize dog subscription: full week or selected days
  DogSubscription.create!(
    dog: dog,
    monday: [true, false].sample,
    tuesday: [true, false].sample,
    wednesday: [true, false].sample,
    thursday: [true, false].sample,
    friday: [true, false].sample
  )

  dog
end

# Create shifts for the week (Monday to Friday, morning and afternoon)
shifts = []
(1..5).each do |day|
  date = Date.today.beginning_of_week + day # Monday to Friday
  %w[morning afternoon].each do |time_of_day|
    shifts << Shift.create!(date: date, time_of_day: time_of_day)
  end
end

# Assign some dogs to shifts, create dog schedules, and assign walkers to vans
shifts.each do |shift|
  assigned_dogs = dogs.sample(rand(10..12)) # Assign random dogs (up to 12 per shift)

  assigned_dogs.each do |dog|
    # Create a schedule for the dog for this shift
    status = DogSchedule.statuses.keys.sample # Random status for demonstration
    DogSchedule.create!(dog: dog, shift: shift, status: status)

    # Assign random dog walkers to the shift with vans
    walker = walkers.sample
    van = vans.sample

    # Ensure the walker is assigned to this shift with a van
    unless Assignment.exists?(user: walker, shift: shift, van: van)
      Assignment.create!(user: walker, shift: shift, van: van)
    end
  end
end

puts "Seed data created successfully!"
