module Leads
  class FlSearchIndustry < Sequel::Model(:fl_search_industry)
    many_to_one :fl_search, :class=>:'Leads::FlSearch', :key=>:id_search
    many_to_one :fl_industry, :class=>:'Leads::FlSearchIndustry', :key=>:id_industry

    # constructor
    def initialize(h)
      super()
      errors = Leads::FlSearchIndustry.validate_descriptor(h)
      raise "Errors found:\n#{errors.join("\n")}" if errors.size>0
      # map the hash to the attributes of the model.
      self.id = guid
      self.id_search = h[:id_search]
      self.id_industry = h[:id_industry]
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
