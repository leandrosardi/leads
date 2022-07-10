module Leads
  class FlSearch < Sequel::Model(:fl_search)
    include BlackStack::TableHelper

    many_to_one :user, :class=>:'BlackStack::MySaaS::User', :key=>:id_user
    one_to_many :positions, :class=>'Leads::FlSearchPosition', :key=>:id_search
    one_to_many :locations, :class=>'Leads::FlSearchLocation', :key=>:id_search
    one_to_many :industries, :class=>'Leads::FlSearchIndustry', :key=>:id_search
    
    def self.validate_descriptor(h)
      errors = []
      
      # validate: h must be a hash
      errors << "Descriptor must be a hash" if !h.is_a?(Hash)

      if h.is_a?(Hash)
        # validate: :id_user is mandatory
        errors << "id_user is mandatory" if h['id_user'].to_s.size == 0

        # validate: :name is mandatory
        errors << "name is mandatory" if h['name'].to_s.size == 0

        # validate: the value of :id_user must be a valid guid
        errors << "id_user must be a valid guid" if h['id_user'].to_s.size > 0 && !h['id_user'].guid?

        # validate: the value of :name must be a valid string
        errors << "name must be a valid string" if !h['name'].is_a?(String)

        # validate: the value of :description must be nil, or must be a valid string not empty
        errors << "description must be nil or a valid string" if (
          (h['description'].is_a?(String) && h['description'].to_s.size == 0) ||
          (!h['description'].nil? && !h['description'].is_a?(String))
        )

        # validate: the value of :saved must be a valid boolean
        errors << "saved must be a valid boolean" if !h['saved'].is_a?(TrueClass) && !h['saved'].is_a?(FalseClass)
        
        # validate: the value of :no_of_results must be a valid integer or nil
        errors << "no_of_results must be a valid integer or nil" if !h['no_of_results'].is_a?(Integer) && !h['no_of_results'].nil?

        # validate: the value of :no_of_companies must be a valid integer or nil or nil
        errors << "no_of_companies must be a valid integer or nil" if !h['no_of_companies'].is_a?(Integer) && !h['no_of_companies'].nil?

        # validation: 'positions' must be nil or an array
        errors << "positions must be nil or an array" if !h['positions'].nil? && !h['positions'].is_a?(Array)

        # validation: 'locations' must be nil or an array
        errors << "locations must be nil or an array" if !h['locations'].nil? && !h['locations'].is_a?(Array)

        # validation: 'industries' must be nil or an array
        errors << "industries must be nil or an array" if !h['industries'].nil? && !h['industries'].is_a?(Array)
        
        # validation: if 'positions' is an array, each element must be valid
        if !h['positions'].nil? && h['positions'].is_a?(Array)
          h['positions'].each do |p|
            errors += FlSearchPosition.validate_descriptor(p)
          end
        end

        # validation: if 'locations' is an array, each element must be valid
        if !h['locations'].nil? && h['locations'].is_a?(Array)
          h['locations'].each do |l|
            errors += FlSearchLocation.validate_descriptor(l)
          end
        end
        
        # validation: if 'industries' is an array, each element must be valid
        if !h['industries'].nil? && h['industries'].is_a?(Array)
          h['industries'].each do |i|
            errors += FlSearchIndustry.validate_descriptor(i)
          end
        end
      end

      errors
    end

    # map a hash descriptor to the attributes of the object
    def update(h)
      self.name = h['name']
      self.description = h['description']
      self.id_user = h['id_user']
      self.saved = h['saved']
      self.no_of_results = h['no_of_results']
      self.no_of_companies = h['no_of_companies']
=begin # a saved search shouldn't be updated never
      # remove all positions
      self.positions.each do |p|
        p.delete
      end
      # remove all locations
      self.locations.each do |l|
        l.delete
      end
      # remove all industries
      self.industries.each do |i|
        i.delete
      end
=end
      # map the array of positions
      if !h['positions'].nil? && h['positions'].is_a?(Array)
        h['positions'].each { |p| self.positions << FlSearchPosition.new(p) }
      end
      # map the array of locations
      if !h['locations'].nil? && h['locations'].is_a?(Array)
        h['locations'].each { |l| self.locations << FlSearchLocation.new(l) }
      end
      # map the array of industries
      if !h['industries'].nil? && h['industries'].is_a?(Array)
        h['industries'].each { |i| self.industries << FlSearchIndustry.new(i) }
      end
    end

    # save this object, and all the objects of the associations
    def save
      super
      self.positions.each { |p| 
        p.id_search=self.id
        p.save 
      }
      self.locations.each { |l| 
        l.id_search=self.id
        l.save
      }
      self.industries.each { |i| 
        i.id_search=self.id
        i.save
      }
    end

    # constructor
    def initialize(h)
      super()
      errors = Leads::FlSearch.validate_descriptor(h)
      raise "Errors found:\n#{errors.join("\n")}" if errors.size>0
      # map the hash to the attributes of the model.
      self.id = guid
      self.create_time = now
      self.update(h)
      self
    end

    # This method works with the TableHelper module.
    # Return the FROM-WHERE part of the SQL query to retrieve the results of the table, with not pagination nor sorting, nor listed columns.
    # This method is used to build custom queries on other methods.
    #
    # if id_account is not nil, the query will return the number of export lists of such an account where the lead is included.
    # if id_account is nil, the query will return the number of all export lists where the lead is included.
    # 
    def core(options={})
      id_account = options[:id_account]
      exports = id_account.nil? ? [] : Leads::Account.where(:id=>id_account).exports

      # si no se especifica una cuenta, o si la cuenta no tienen export lists
      if id_account.nil? || exports.size == 0
        q0 = "
          FROM fl_lead l
          WHERE 1=1
        "
      else
        q0 = "
          FROM fl_lead l
          LEFT JOIN fl_export_lead el ON el.id_lead=l.id
          WHERE el.id_export IN ('#{exports.map {|e| e.id}.join("','")}')
        "
      end

      # filter by positive job positions
      a = self.positions.select { |p| p.positive }
      if a.size > 0
        q0 += " AND ( "
        a.each_with_index do |p,i|
          q0 += " l.position LIKE '%#{p.value.to_s.to_sql}%' "
          q0 += " OR " if i<a.size-1
        end
        q0 += " ) "
      end # if a.size > 0

      # filter by negative job positions
      a = self.positions.select { |p| !p.positive }
      if a.size > 0
        a.each_with_index do |p,i|
          q0 += " AND NOT l.position LIKE '%#{p.value.to_s.to_sql}%' "
        end
      end

      # filter by positive locations
      a = self.locations.select { |l| l.positive }
      if a.size > 0
        q0 += " AND ( "
        a.each_with_index do |l,i|
          q0 += " l.stat_location_name LIKE '%#{l.value.to_s.to_sql}%' "
          q0 += " OR " if i<a.size-1
        end
        q0 += " ) "
      end

      # filter by negative locations
      a = self.locations.select { |l| !l.positive }
      if a.size > 0
        a.each_with_index do |l,i|
          q0 += " AND NOT l.stat_location_name LIKE '%#{l.value.to_s.to_sql}%' "
        end
      end

      # filter by positive industries
      a = self.industries.select { |i| i.positive }
      if a.size > 0
        q0 += " AND ("
        a.each_with_index do |i,k|
          q0 += " l.stat_industry_name LIKE '%#{i.fl_industry.name.to_s.to_sql}%' "
          q0 += " OR " if k<a.size-1
        end
        q0 += " ) "
      end

      # filter by negative industries
      a = self.industries.select { |i| !i.positive }
      if a.size > 0
        a.each_with_index do |i,k|
          q0 += " AND NOT l.stat_industry_name LIKE '%#{i.fl_industry.name.to_s.to_sql}%' "
        end
      end
      
      # return
      q0
    end

    # This method works with the TableHelper module.
    # return an array of hashes with the columns of the table
    def columns
      [
        { 'query_field' => 'l.id' }, 
        {
          'query_field' => 'l.name',
          # braninstorm a general-pourpose screen descriptor
=begin
          'visible' => true,
          'label' => 'Name',
          'sortable' => true,
          'searchable' => {
            'search_type' => 'text' # text, integer, float, boolean, date, date-range, datetime, select, multiselect
            'autocomplete_values' => {
              'values' => [],
              'strict' => false, # true or false - don't allow to filters outside the list of possible values
            },
          }
=end        
        },
        { 'query_field' => 'l.position' }, 
        { 'query_field' => 'l.stat_company_name' }, 
        { 'query_field' => 'l.stat_industry_name' },
        { 'query_field' => 'l.stat_location_name' },
        { 'query_field' => 'l.stat_has_email' },
        { 'query_field' => 'l.stat_has_phone' },  
      ]
    end

    # reurn an array of lead objects who match with the filters of the search.
    def leads(h)
      self.rows(h).map { |row| 
        Leads::FlLead.where(:id=>row[:id]).first 
        # release resources
        GC.start
        DB.disconnect
      }
    end

    # total number of unique companies with leads mathcing with this search
    def count_companies
      DB["SELECT COUNT(DISTINCT id_company) AS n #{self.core}"].first[:n]
    end
  end # class FlSearch
end # module Leads
