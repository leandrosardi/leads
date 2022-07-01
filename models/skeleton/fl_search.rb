module Leads
  class FlSearch < Sequel::Model(:fl_search)
    many_to_one :user, :class=>:'BlackStack::MySaaS::User', :key=>:id_user

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
