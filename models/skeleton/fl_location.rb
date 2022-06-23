module Leads
  class FlLocation < Sequel::Model(:fl_location)

    # validate the strucutre of the hash descritpor.
    # return an arrow of strings with the errors found. 
    def self.validate_descriptor(h)
      errors = []

      # validate: h must be a hash
      errors << "Descriptor must be a hash" if !h.is_a?(Hash)

      # validate: if :company is a hash, then it must have :name
      errors << "Descriptor :location must have :name" if h.is_a?(Hash) && !h.has_key?(:name)

      if !Leads::FlLocation.where(:name=>h[:name]).first
        errors << "Descriptor :location :name #{h[:name]} not valid"
      end

      # return the errors found.
      errors
    end

  end
end
