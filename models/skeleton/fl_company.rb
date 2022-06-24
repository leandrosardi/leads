module Leads
  class FlCompany < Sequel::Model(:fl_company)
    one_to_many :fl_leads, :class=>:'Leads::FlLeads', :key=>:id_company

    # validate the strucutre of the hash descritpor.
    # return an arrow of strings with the errors found. 
    def self.validate_descriptor(h)
      errors = []

      # validate: h must be a hash
      errors << "Descriptor must be a hash" if !h.is_a?(Hash)

      # validate: if it has :url, then :url must be a valid URL
      if h.is_a?(Hash) && h.has_key?(:url)
        begin
          URI.parse(h[:url])
        rescue URI::InvalidURIError
          errors << "Descriptor :company :url must be a valid URL"
        end
      end

      # validate: if :company is a hash, then it must have :name
      errors << "Descriptor :company must have :name" if h.is_a?(Hash) && !h.has_key?(:name)

      # return the errors found.
      errors
    end

    # return a hash descriptor for the data.
    def to_h
      { :name => name, :url => url }
    end

  end
end
