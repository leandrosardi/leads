module Leads
  class FlSearchLocation < Sequel::Model(:fl_search_location)
    many_to_one :fl_search, :class=>:'Leads::FlSearch', :key=>:id_search
    many_to_one :fl_location, :class=>:'Leads::FlSearchLocation', :key=>:id_location

    # constructor
    def initialize(h)
      super()
      errors = Leads::FlSearchLocation.validate_descriptor(h)
      raise "Errors found:\n#{errors.join("\n")}" if errors.size>0
      # map the hash to the attributes of the model.
      self.id = guid
      self.id_search = h[:id_search]
      self.value = h[:value]
      self.positive = h[:positive]
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
