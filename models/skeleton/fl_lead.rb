module Leads
  class FlLead < Sequel::Model(:fl_lead)
    many_to_one :fl_company, :class=>:'Leads::FlCompany', :key=>:id_company
    many_to_one :fl_industry, :class=>:'Leads::FlSearchIndustry', :key=>:id_industry
    many_to_one :fl_location, :class=>:'Leads::FlSearchLocation', :key=>:id_location
    one_to_many :fl_datas, :class=>:'Leads::FlData', :key=>:id_lead
    one_to_many :fl_export_leads, :class=>'Leads::FlExportLead', :key=>:id_lead
    
    # get all the extensions
    def exports
      self.fl_export_leads.map{|e| e.fl_export}
    end

    # validate the strucutre of the hash descritpor.
    # return an arrow of strings with the errors found. 
    def self.validate_descriptor(h)
      errors = []

      # validate: h must be a hash
      errors << "Descriptor must be a hash. Received: #{h.to_s}" if !h.is_a?(Hash)

      if h.is_a?(Hash)
        # validate: :name is required
        errors << "Descriptor must have a :name (#{h})" if !h.has_key?('name')

        # validate: :name is a string
        errors << "Descriptor :name must be a string" if h.has_key?('name') && !h['name'].is_a?(String)

        # validate: if :company is a hash, validate it
        errors += Leads::FlCompany::validate_descriptor(h['company']) if h.has_key?('company') && h['company'].is_a?(Hash)

        # validate: :industry is string or is nil
        errors << "Descriptor :industry must be a string or nil" if !h['industry'].is_a?(String) && !h['industry'].nil?

        # validate: if :industry is a string, validate it
        if h.has_key?('industry') && h['industry'].is_a?(String)
          errors += Leads::FlIndustry::validate_descriptor({ 'name' => h['industry'] })
        end

        # validate: :location is string or is nil
        errors << "Descriptor :location must be a string or nil" if !h['location'].is_a?(String) && !h['location'].nil?

        # validate: if :location is a string, validate it
        if h.has_key?('location') && h['location'].is_a?(String)
          errors += Leads::FlLocation::validate_descriptor({ 'name' => h['location'] })
        end

        # validate: :datas is required
        errors << "Descriptor must have a :datas (#{h})" if !h.has_key?('datas')

        # validate: :datas is an array of hashes
        errors << "Descriptor :datas must be an array of hashes" if h['datas'].is_a?(Array) && h['datas'].select{|d| !d.is_a?(Hash)}.size>0

        # validate: :datas must have at least 1 email
        errors << "Descriptor :datas must have at least 1 email (#{h['datas'].to_s})" if h['datas'].is_a?(Array) && h['datas'].select{|d| d['type']==Leads::FlData::TYPE_EMAIL}.size==0

        # validate: if :datas is an array, then validate each element of the array
        if h.has_key?('datas') && h['datas'].is_a?(Array)
          h['datas'].each do |d|
            errors += Leads::FlData::validate_descriptor(d)
          end
        end
      end # if h.is_a?(Hash)

      # return the errors found.
      errors
    end

    # what happen if the lead works in more than 1 company (example: founder of 2 companies) --> create 2 records
    def initialize(h)
      super()
      errors = Leads::FlLead.validate_descriptor(h)
      raise "Errors found:\n#{errors.join("\n")}" if errors.size>0
      # map the hash to the attributes of the model.
      self.id = guid()
      self.update(h)
    end

    # save the company.
    # save the lead itself.
    # save each data.
    def save
      self.fl_company.save if !self.fl_company.nil?
      super
      self.fl_datas.each { |d|
        d.id_lead = self.id 
        d.save 
      }
    end

    # map the name attribues name, position, industry, location to the model.
    # if exsits a company with the same url, then use it. otherwise, create a new company.
    # add the datas to the exisitig ones.
    def update(h)
      self.name = h['name']
      self.position = h['position']

      # if exsits a company with the same url, then use it.
      if h['company'].is_a?(Hash)
        self.fl_company = Leads::FlCompany.merge(h['company'])
        self.stat_company_name = self.fl_company.name
      end

      # map the FlIndustry to the model.
      if h['industry'].is_a?(String)
        self.fl_industry = Leads::FlIndustry.where(:name=>h['industry']).first 
        self.stat_industry_name = h['industry']
      end # if h['industry'].is_a?(String)

      # map the FlLocation to the model.
      # reference: https://github.com/leandrosardi/leads/issues/33
      if h['location'].is_a?(String)
        o = Leads::FlLocation.where(:name=>h['location']).first
        self.fl_location = o if !o.nil?
        self.stat_location_name = h['location']
      end

      # if :data is an array, then add each data which value does not exist in the existing ones.
      if h['datas'].is_a?(Array)
        h['datas'].each do |d|
          d['value'].downcase!
          self.fl_datas << Leads::FlData.new(d) unless self.fl_datas.select{ |dd| dd.value==d['value'] }.size>0
        end
      end

      # activate this flag if the lead has a data with type==TYPE_EMAIL
      self.stat_has_email = self.fl_datas.select{ |dd| dd.type==Leads::FlData::TYPE_EMAIL }.size>0

      # activate this flag if the lead has a data with type==TYPE_PHONE
      self.stat_has_phone = self.fl_datas.select{ |dd| dd.type==Leads::FlData::TYPE_PHONE }.size>0
    end

    # build an array of exisiting lead ids, with one or more of the emails in the descriptor.
    def self.merge(h)
      errors = Leads::FlLead.validate_descriptor(h)
      raise "Errors found (#{errors.size.to_s}):\n#{errors.join("\n")}" if errors.size>0

      # build an array of exisiting lead ids, with one or more of the emails in the descriptor.
      ids = []
      if h['datas'].is_a?(Array) && h['datas'].select { |d| d['type'] == Leads::FlData::TYPE_EMAIL }.size>0
        ids = Leads::FlData.where(
          :type => Leads::FlData::TYPE_EMAIL,
          :value => h['datas'].select { |d| 
            d['type'] == Leads::FlData::TYPE_EMAIL 
          }.map { |d| d['value'].downcase }
        ).all.map{ |d| 
          d.id_lead
        }.uniq
      end

      # if there is more than one lead with the emails of this lead, raise an error.
      raise "More than one lead with the same emails found: #{h['datas'].map{|d| d['value']}.uniq.join(', ')}" if ids.size>1

      # if the lead already exists, then update it and return it.
      if ids.size==1
        o = Leads::FlLead.where(:id => ids.first).first
        o.update(h)
        return o
      end

      # if there is no lead with the same email, create a new one and return it.
      return Leads::FlLead.new(h)

    end

    # receive an array of hash-descriptors
    # return an array of Leads::FlLead objects.
    #
    def self.merge_many(h)
      raise ":leads must be an array. Received: #{h.to_s}" if !h['leads'].is_a?(Array)
      ret = []
      h['leads'].each { |l| ret << Leads::FlLead.merge(l) }
      ret
    end

    # return a hash descriptor for the data.
    def to_hash
      ret = { 
        'name' => name, 
        'position' => position, 
      }
      ret['company'] = self.fl_company.nil? ? nil : self.fl_company.to_hash
      ret['industry'] = self.fl_industry.nil? ? nil : self.fl_industry.name
      ret['location'] = self.fl_location.nil? ? nil : self.fl_location.name
      ret['datas'] = self.fl_datas.map{|d| d.to_hash}
      # return
      ret
    end
  end
end
