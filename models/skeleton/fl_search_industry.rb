module Leads
  class FlSearchIndustry < Sequel::Model(:fl_search_industry)
    many_to_one :fl_search, :class=>:'Leads::FlSearch', :key=>:id_search
    many_to_one :fl_industry, :class=>:'Leads::FlSearchIndustry', :key=>:id_industry

    def self.validate_descriptor(h)
      errors = []
      # validate: h must be a hash
      errors << "Descriptor must be a hash" if !h.is_a?(Hash)
      # hash validations
      if h.is_a?(Hash)
        # validation: key 'name' is mandatory
        errors << "Key 'name' is mandatory" if !h.has_key?('name')

        # validation: key 'positive' is mandatory
        errors << "Key 'positive' is mandatory" if !h.has_key?('positive')

        # validation: value 'name' must exists in the table fl_industry
        if h.has_key?('name')
          industry = FlIndustry.where(:name=>h['name']).first
          errors << "Value 'name' must exists in the table fl_industry" if industry.nil?
        end

        # validation: value 'positive' must be a boolean
        if h.has_key?('positive')
          errors << "Value 'positive' must be a boolean" if !h['positive'].is_a?(TrueClass) && !h['positive'].is_a?(FalseClass)
        end
      end
      # return
      errors
    end # validate_descriptor

    # map a hash descriptor to the attributes of the object
    def update(h)
      self.id_industry = Leads::FlIndustry.where(:name=>h['name']).first.id
      self.positive = h['positive']
    end

    # constructor
    def initialize(h)
      super()
      errors = Leads::FlSearchIndustry.validate_descriptor(h)
      raise "Errors found:\n#{errors.join("\n")}" if errors.size>0
      # map the hash to the attributes of the model.
      self.id = guid
      self.update(h)
    end

  end # FlSearchIndustry
end # Leads
