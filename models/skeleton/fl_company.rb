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
      if h.is_a?(Hash) && h.has_key?('url')
        begin
          URI.parse(h['url'])
        rescue URI::InvalidURIError
          errors << "Descriptor :company :url must be a valid URL"
        end
      end

      # validate: if :company is a hash, then it must have :name
      errors << "Descriptor :company must have :name" if h.is_a?(Hash) && !h.has_key?('name')

      # validate: if the key :url exists, its value is a valid url
      if h.is_a?(Hash) && h.has_key?('url')
        errors << "Descriptor :company :url must be a valid URL" if !h['url'].to_s.url?
      end

      # return the errors found.
      errors
    end

    # normalize the url in the hash descriptor, getting the domain with its subdomains, except `www.`, and finally downcasing it.
    # this method should not be called by the user.
    def self.normalize_url(url)
      return nil if url.nil?
      return nil if !url.to_s.url?
      # get the domain with its subdomains, except www.
      url.to_s.gsub(/^https?:\/\//, '').gsub(/www\./, '').gsub(/\/.*$/, '').downcase
    end

    # normalize the url in the hash descriptor.
    # if exsits a company with the same normalized url, then return it. otherwise, create a new company.
    def self.merge(h)
      # validate h is a hash
      raise "Compny descriptor must be a hash" if !h.is_a?(Hash)

      # initialize :url
      h['url'] = nil if !h.has_key?('url')

      # normalize the url in the hash descriptor.
      h['url'] = Leads::FlCompany.normalize_url(h['url']) if !h['url'].nil?

      if !h['url'].nil?
        # if exsits a company with the same normalized url, then return it.
        company = Leads::FlCompany.where(:url => h['url']).first
        if !company.nil?
          return company
        else
          # otherwise, create a new company.
          return self.new(h)
        end
      else # if :url is nil, then match the company name.
        return self.new(h)
      end
    end

    # constructor
    def initialize(h)
      super()
      errors = Leads::FlCompany.validate_descriptor(h)
      raise "Errors found:\n#{errors.join("\n")}" if errors.size>0
      # map the hash to the attributes of the model.
      self.id = guid
      self.name = h['name']
      self.url = Leads::FlCompany.normalize_url(h['url'])
    end

    # return a hash descriptor for the data.
    def to_h
      { 'name' => name, 'url' => url }
    end

  end
end
