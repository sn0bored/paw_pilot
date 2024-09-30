# frozen_string_literal: true

module AiServices
  class OptimizeShiftService
    def initialize(shift_id)
      @shift = Shift.find(shift_id)
      @client = OpenAI::Client.new
    end

    def optimize
      response = call_openai
      return if response.nil?

      dog_batches = JSON.parse(response['choices'][0]['message']['function_call']['arguments'])['dog_batches']
      assign_dogs_to_walkers(dog_batches)
    end

    private

    def call_openai
      @client.chat(
        parameters: {
          model: ENV.fetch('GPT_COMPLETIONS_MODEL', 'gpt-4o-2024-08-06'),
          messages: [{ role: "user", content: prompt }],
          functions: functions,
          function_call: { name: "group_dogs" }
        }
      )
    rescue StandardError => e
      Rails.logger.error "Error in CallOpenAI In OptimizeShiftService: #{e.message}"
      Bugsnag.notify("Error in CallOpenAI In OptimizeShiftService: #{e.message}")
      nil
    end

    def prompt
      available_dogs = Dog.joins(:dog_subscription)
                          .where("dog_subscriptions.day_length IN (?) OR dog_subscriptions.day_length = ?", 
                                 [DogSubscription.day_lengths[@shift.time_of_day], DogSubscription.day_lengths['full']], 
                                 DogSubscription.day_lengths['full'])
                          .where.not(id: @shift.dogs.pluck(:id))

      dogs_list = available_dogs.map { |dog| { id: dog.id, zip_code: dog.zip_code }.to_json }.join(",\n")

      <<~PROMPT
        You are tasked with organizing dog walking routes for our service. We have a list of dogs, each with an ID and a ZIP Code. Please group these dogs into batches, each containing up to 12 dogs, ensuring that the dogs in each batch are geographically close to one another based on their ZIP Codes. The goal is to minimize the total number of batches while making it efficient for a walker to pick up the dogs in each batch.

        Important rules:
        1. Each batch must contain no more than 12 dogs.
        2. Dogs in each batch should be geographically close based on their ZIP Codes.

        To determine if ZIP Codes are close:
        1. Compare the first three digits of the ZIP Codes. These represent larger geographical areas.
        2. If the first three digits are the same, the ZIP Codes are likely close.
        3. If the first three digits differ, compare the first two digits. ZIP Codes with the same first two digits are generally in the same state or region.
        4. For ZIP Codes with different first two digits, use this formula to estimate distance:
           distance = |ZIP1 - ZIP2|
           Lower values indicate closer proximity.

        Here is the list of dogs:
        #{dogs_list}

        Please provide the output in JSON format as follows:

        {
          "dog_batches": [
            [1, 2, 3],
            [4, 5, 6],
            ...
          ]
        }

        Ensure that each batch is optimized for geographical proximity using the guidelines provided above.
      PROMPT
    end

    def functions
      [
        {
          "name": "group_dogs",
          "description": "Groups dogs into batches based on ZIP Code proximity",
          "parameters": {
            "type": "object",
            "properties": {
              "dog_batches": {
                "type": "array",
                "description": "An array where each element is a batch (array) of up to 12 dog IDs",
                "items": {
                  "type": "array",
                  "items": {
                    "type": "integer",
                    "description": "Dog ID"
                  }
                }
              }
            },
            "required": ["dog_batches"]
          }
        }
      ]
    end

    def assign_dogs_to_walkers(dog_batches)
      walkers = User.where(role: [:dog_walker, :manager])
      dog_batches.each_with_index do |batch, index|
        walker = walkers[index % walkers.count]
        
        batch.each do |dog_id|
          if Dog.where(id: dog_id).present?
            @shift.dog_schedules.create(dog_id: dog_id, user_id: walker.id)
          end
        end
      end
    end
  end
end
