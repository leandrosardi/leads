module Leads
  class FlLead < Sequel::Model(:fl_lead)
    many_to_one :fl_company, :class=>:'Leads::FlCompany', :key=>:id_company
    many_to_one :fl_industry, :class=>:'Leads::FlSearchIndustry', :key=>:id_industry
    many_to_one :fl_location, :class=>:'Leads::FlSearchLocation', :key=>:id_location
    one_to_many :fl_datas, :class=>:'Leads::FlData', :key=>:id_lead

    # validate the strucutre of the hash descritpor.
    # return an arrow of strings with the errors found. 
    def self.validate_descriptor(h)
      errors = []

      # validate: h must be a hash
      errors << "Descriptor must be a hash" if !h.is_a?(Hash)

      if h.is_a?(Hash)
        # validate: :name is required
        errors += "Descriptor must have a :name" if !h.has_key?(:name)

        # validate: :name is a string
        errors += "Descriptor :name must be a string" if h.has_key?(:name) && !h[:name].is_a?(String)

        # validate: if :company is a hash, validate it
        errors += Leads::FlCompany::validate_descriptor(h[:company]) if h.has_key?(:company) && h[:company].is_a?(Hash)

        # validate: :industry is string or is nil
        errors << "Descriptor :industry must be a string or nil" if !h[:industry].is_a?(String) && !h[:industry].nil?

        # validate: if :industry is a string, validate it
        if h.has_key?(:industry) && h[:industry].is_a?(String)
          errors += Leads::FlIndustry::validate_descriptor({ :name => h[:industry] })
        end

        # validate: :location is string or is nil
        errors << "Descriptor :location must be a string or nil" if !h[:location].is_a?(String) && !h[:location].nil?

        # validate: if :location is a string, validate it
        if h.has_key?(:location) && h[:location].is_a?(String)
          errors += Leads::FlLocation::validate_descriptor({ :name => h[:location] })
        end

        # validate: :datas is an array or is nil
        errors << "Descriptor :datas must be an array or nil" if !h[:datas].is_a?(Array) && !h[:datas].nil?
          
        # validate: if :datas is an array, then validate each element of the array
        if h.has_key?(:datas) && h[:datas].is_a?(Array)
          h[:datas].each do |d|
            errors += Leads::FlData::validate_descriptor(d)
          end
        end
      end # if h.is_a?(Hash)

      # return the errors found.
      errors
    end

    # what happen if the lead works in more than 1 company (example: founder of 2 companies) --> create 2 records
    def initialize(h)
      errors = self.class.validate_descriptor(h)
      raise "Errors found:\n#{errors.join("\n")}" if errors.size>0

      # map the hash to the attributes of the model.
      self.id = guid
      self.update(h)
    end

    # map the name attribues name, position, industry, location to the model.
    # if exsits a company with the same url, then use it. otherwise, create a new company.
    # add the datas to the exisitig ones.
    def update(h)
      self.name = h[:name]
      self.position = h[:position]

      # if exsits a company with the same url, then use it.
      self.fl_company = Leads::FlCompany.merge(h[:company]) if h[:company].is_a?(Hash)

      # map the FlIndustry to the model.
      self.fl_industry = Leads::FlIndustry.where(:name=>h[:industry]).first if h[:industry].is_a?(String)

      # map the FlLocation to the model.
      self.fl_location = Leads::FlLocation.where(:name=>h[:location]).first if h[:location].is_a?(String)

      # if :data is an array, then add each data which value does not exist in the existing ones.
      if h[:datas].is_a?(Array)
        h[:datas].each do |d|
          self.fl_datas << Leads::FlData.new(d) unless self.fl_datas.select{ |dd| dd.value==d[:value] }.size>0
        end
      end
    end

    # build an array of exisiting lead ids, with one or more of the emails in the descriptor.
    def self.merge(h)
      errors = self.class.validate_descriptor(h)
      raise "Errors found:\n#{errors.join("\n")}" if errors.size>0

      # build an array of exisiting lead ids, with one or more of the emails in the descriptor.
      if h[:datas].is_a?(Array) && h[:datas].select { |d| d[:type] == Leads::FlData::TYPE_EMAIL }.size>0
        ids = BlackStack::FlData.where(
          :type => Leads::FlData::TYPE_EMAIL, 
          :value => h[:datas].select { |d| 
            d[:type] == Leads::FlData::TYPE_EMAIL 
          }.map{ |d| 
            d[:value]
          }.uniq
        ).map{ |d| 
          d.id_lead
        }.uniq
      end

      # if there is more than one lead with the emails of this lead, raise an error.
      raise "More than one lead with the same emails found: #{h[:datas].map{|d| d[:value]}.uniq.join(', ')}" if ids.size>1

      # if the lead already exists, then update it and return it.
      if ids.size==1
        o = BlackStack::FlLead.where(:id => ids.first).first
        o.update(h)
        return o
      end

      # if there is no lead with the same email, create a new one.
      return BlackStack::FlLead.new(h)
    end

    # return a hash descriptor for the data.
    def to_h
      { 
        :name => name, 
        :position => position, 
        :company => self.fl_company.to_hash, 
        :industry => self.fl_industry.name, 
        :location => self.fl_location.name,
        :datas => self.fl_datas.map{|d| d.to_hash},
      }
    end

  end
end
