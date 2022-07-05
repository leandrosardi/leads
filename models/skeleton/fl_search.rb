module Leads
  class FlSearch < Sequel::Model(:fl_search)
    many_to_one :user, :class=>:'BlackStack::MySaaS::User', :key=>:id_user

    def self.validate_descriptor(h)
      errors = []
      
      # validate: h must be a hash
      errors << "Descriptor must be a hash" if !h.is_a?(Hash)

      if h.is_a?(Hash)
        # validate: :id_user is mandatory
        errors << "id_user is mandatory" if h[:id_user].to_s.size == 0

        # validate: :name is mandatory
        errors << "name is mandatory" if h[:name].to_s.size == 0

        # validate: the value of :id_user must be a valid guid
        errors << "id_user must be a valid guid" if !h[:id_user].is_a?(String) || h[:id_user].guid?

        # validate: the value of :name must be a valid string
        errors << "name must be a valid string" if !h[:name].is_a?(String)

        # validate: the value of :description must be nil, or must be a valid string not empty
        errors << "description must be nil or a valid string" if (
          (h[:description].is_a?(String) && h[:description].to_s.size == 0) || 
          (!h[:description].nil? && !h[:description].is_a?(String))
        )

        # validate: the value of :saved must be a valid boolean
        errors << "saved must be a valid boolean" if !h[:saved].is_a?(TrueClass) && !h[:saved].is_a?(FalseClass)
        
        # validate: the value of :no_of_results must be a valid integer or nil
        errors << "no_of_results must be a valid integer" if !h[:no_of_results].is_a?(Integer) && !h[:no_of_results].nil?

        # validate: the value of :no_of_companies must be a valid integer or nil or nil
        errors << "no_of_companies must be a valid integer" if !h[:no_of_companies].is_a?(Integer) && !h[:no_of_companies].nil?

      end

      errors
    end

    # constructor
    def initialize(h)
      super()
      errors = Leads::FlSearch.validate_descriptor(h)
      raise "Errors found:\n#{errors.join("\n")}" if errors.size>0
      # map the hash to the attributes of the model.
      self.id = guid
      self.id_user = h[:id_user]
      self.name = h[:name]
      self.description = h[:description]
      self.saved = h[:saved]
      self.no_of_results = h[:no_of_results]
      self.no_of_companies = h[:no_of_results]
      self.creation_time = now
    end

    # validate the strucutre of the hash descritpor.
    # return an arrow of strings with the errors found.
    def self.validate_descriptor(h)
      errors = []

      # validate: h must be a hash
      errors << "Descriptor must be a hash" if !h.is_a?(Hash)

      # return the errors found.
      errors
    end
  end
end
