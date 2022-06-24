module Leads
  class FlIndustry < Sequel::Model(:fl_industry)

    # validate the strucutre of the hash descritpor.
    # return an arrow of strings with the errors found. 
    def self.validate_descriptor(h)
      errors = []

      # validate: h must be a hash
      errors << "Descriptor must be a hash" if !h.is_a?(Hash)

      # validate: if :company is a hash, then it must have :name
      errors << "Descriptor :industry must have :name" if h.is_a?(Hash) && !h.has_key?(:name)

      if h[:industry].is_a?(String)
        if !Leads::FlIndustry.where(:name=>h[:name]).first
          errors << "Descriptor :industry :name #{h[:name]} not valid"
        end
      end

      # return the errors found.
      errors
    end

    # constructor
    def initialize(h)
      errors = self.class.validate_descriptor(h)
      raise "Errors found:\n#{errors.join("\n")}" if errors.size>0
      # map the hash to the attributes of the model.
      self.id = guid
      self.name = h[:name]
    end

    # return a hash descriptor for the data.
    def to_h
      { :name => name }
    end

  end
end
