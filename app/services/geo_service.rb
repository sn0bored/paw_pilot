require 'kmeans-clusterer'

class GeoService
  MAX_CLUSTER_SIZE = 12

  def initialize(shift_id)
    @shift = Shift.find(shift_id)
    @walkers = User.where(role: [:dog_walker, :manager]).to_a
    @number_of_walkers = @walkers.size
    @total_capacity = @number_of_walkers * MAX_CLUSTER_SIZE
  end

  def optimize
    @dogs = fetch_dogs
    total_dogs = @dogs.size
    puts "Total dogs fetched: #{total_dogs}"
    puts "Number of walkers: #{@number_of_walkers}"
    puts "Total capacity: #{@total_capacity}"

    # Step 1: Initial Clustering
    clusters = initial_clustering

    # Step 2: Adjust Clusters to Respect Capacity Constraints
    clusters, unassigned_dogs = adjust_clusters(clusters)

    # Step 3: Assign Unassigned Dogs to Clusters with Available Capacity
    clusters = assign_unassigned_dogs(clusters, unassigned_dogs)

    # Step 4: Assign Clusters to Walkers
    assign_dogs_to_walkers(clusters)

    # Report on unassigned dogs
    assigned_dog_ids = clusters.values.flatten.map(&:id)
    unassigned_dogs = @dogs.reject { |dog| assigned_dog_ids.include?(dog.id) }
    puts "Unassigned dogs: #{unassigned_dogs.count}"
    puts "Unassigned dog IDs: #{unassigned_dogs.map(&:id).join(', ')}"
  end

  private

  def initial_clustering
    data_points = @dogs.map do |dog|
      [dog.latitude.to_f, dog.longitude.to_f]
    end

    labels = @dogs.map(&:id)
    k = @number_of_walkers

    # Perform K-Means clustering
    kmeans = KMeansClusterer.run(k, data_points, labels: labels, runs: 5)

    clusters = {}
    kmeans.clusters.each_with_index do |cluster, index|
      cluster_dogs = cluster.points.map { |point| Dog.find(point.label) }
      clusters[index] = cluster_dogs
    end

    puts "Initial clustering complete."
    clusters
  end

  def adjust_clusters(clusters)
    unassigned_dogs = []

    clusters.each do |cluster_id, dogs|
      if dogs.size > MAX_CLUSTER_SIZE
        # Sort dogs by distance to cluster centroid
        centroid = calculate_centroid(dogs)
        dogs.sort_by! { |dog| haversine_distance(dog.latitude, dog.longitude, centroid[0], centroid[1]) }
        # Keep the closest MAX_CLUSTER_SIZE dogs
        clusters[cluster_id] = dogs.take(MAX_CLUSTER_SIZE)
        # Add the rest to unassigned dogs
        unassigned_dogs += dogs.drop(MAX_CLUSTER_SIZE)
      end
    end

    puts "Clusters adjusted to respect capacity constraints."
    [clusters, unassigned_dogs]
  end

  def assign_unassigned_dogs(clusters, unassigned_dogs)
    clusters_with_capacity = clusters.select { |_, dogs| dogs.size < MAX_CLUSTER_SIZE }

    unassigned_dogs.each do |dog|
      # Find the cluster whose centroid is closest to the dog and has available capacity
      closest_cluster_id = nil
      min_distance = Float::INFINITY

      clusters_with_capacity.each do |cluster_id, dogs_in_cluster|
        centroid = calculate_centroid(dogs_in_cluster)
        distance = haversine_distance(dog.latitude, dog.longitude, centroid[0], centroid[1])

        if distance < min_distance
          min_distance = distance
          closest_cluster_id = cluster_id
        end
      end

      if closest_cluster_id
        clusters[closest_cluster_id] << dog
        # Remove cluster from clusters_with_capacity if it reaches MAX_CLUSTER_SIZE
        clusters_with_capacity.delete(closest_cluster_id) if clusters[closest_cluster_id].size >= MAX_CLUSTER_SIZE
        # Break if no clusters have capacity
        break if clusters_with_capacity.empty?
      end
    end

    puts "Unassigned dogs assigned to clusters with available capacity."
    clusters
  end

  def assign_dogs_to_walkers(clusters)
    clusters.each_with_index do |(cluster_id, dogs), index|
      walker = @walkers[index % @walkers.count]

      dogs.each do |dog|
        if Dog.where(id: dog.id).exists?
          @shift.dog_schedules.create(dog_id: dog.id, user_id: walker.id)
        end
      end

      puts "Assigned #{dogs.size} dogs to walker #{walker.id}"
    end
  end

  def fetch_dogs
    Dog.joins(:dog_subscription)
       .where(dog_subscriptions: { day_length: [DogSubscription.day_lengths[@shift.time_of_day], DogSubscription.day_lengths['full']] })
       .where.not(id: @shift.dogs.pluck(:id))
       .select('dogs.id, dogs.latitude, dogs.longitude')
       .to_a
  end

  def haversine_distance(lat1, lon1, lat2, lon2)
    radius = 6371 # Earth's radius in kilometers
    dlat = to_radians(lat2.to_f - lat1.to_f)
    dlon = to_radians(lon2.to_f - lon1.to_f)
    a = Math.sin(dlat / 2)**2 + Math.cos(to_radians(lat1.to_f)) * Math.cos(to_radians(lat2.to_f)) * Math.sin(dlon / 2)**2
    c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a))
    radius * c
  end

  def to_radians(degrees)
    degrees.to_f * Math::PI / 180
  end

  def calculate_centroid(dogs)
    latitudes = dogs.map { |dog| dog.latitude.to_f }
    longitudes = dogs.map { |dog| dog.longitude.to_f }
    [latitudes.sum / latitudes.size, longitudes.sum / longitudes.size]
  end
end
