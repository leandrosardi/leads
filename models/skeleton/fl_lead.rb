module Leads
  class FlLead < Sequel::Model(:fl_lead)
    many_to_one :fl_company, :class=>:'Leads::FlCompany', :key=>:id_company
    many_to_one :fl_industry, :class=>:'Leads::FlSearchIndustry', :key=>:id_industry
    many_to_one :fl_location, :class=>:'Leads::FlSearchLocation', :key=>:id_location
    one_to_many :fl_data, :class=:'Leads::FlData', :key=>:id_lead

    # validate the strucutre of the hash descritpor.
    # return an arrow of strings with the errors found. 
    def self.validate_descriptor(h)
      errors = []

      # validate: h must be a hash
      errors << "Descriptor must be a hash" if !h.is_a?(Hash)

      # validate: :name is required
      errors << "Descriptor must have a :name" if !h.has_key?(:name)

      # validate: :name is a string
      errors << "Descriptor :name must be a string" if !h[:name].is_a?(String)

      # validate: :position is a string or is nil
      errors << "Descriptor :position must be a string or nil" if !h[:position].is_a?(String) && !h[:position].nil?

      # validate: :company is a hash or is nil
      errors << "Descriptor :company must be a hash or nil" if !h[:company].is_a?(Hash) && !h[:company].nil?

      # validate: if :company is a hash, validate it
      errors += Leads::FlCompany::validate_descriptor(h[:company]) if h[:company].is_a?(Hash)

      # validate: :industry is string or is nil
      errors << "Descriptor :industry must be a string or nil" if !h[:industry].is_a?(String) && !h[:industry].nil?

      # validate: if :industry is a string, validate it
      if h[:industry].is_a?(String)
        erros += Leads::FlSearchIndustry::validate_descriptor({ :name => h[:industry] })
      end

      # validate: :location is string or is nil
      errors << "Descriptor :location must be a string or nil" if !h[:location].is_a?(String) && !h[:location].nil?

      # validate: if :location is a string, validate it
      if h[:location].is_a?(String)
        erros += Leads::FlSearchLocation::validate_descriptor({ :name => h[:location] })
      end

      # validate: :datas is an array or is nil
      errors << "Descriptor :datas must be an array or nil" if !h[:datas].is_a?(Array) && !h[:datas].nil?
        
      # validate: if :datas is an array, then validate each element of the array
      if h[:datas].is_a?(Array)
        h[:datas].each do |d|
          errors += Leads::FlData::validate_descriptor(d)
        end
      end

      # return the errors found.
      errors
    end

    # what happen if the lead works in more than 1 company (example: founder of 2 companies) --> create 2 records
    def initialize(h)

    end

  end
end
