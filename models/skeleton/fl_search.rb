module Leads
  class FlSearch < Sequel::Model(:fl_search)
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





    # TODO: move this to a super-module called BlackStack::MySaas::Paginable 
    def validate_pagination_descriptor(h)
      errors = []

      # validation: h must be a hash
      errors << "h must be a hash" if !h.is_a?(Hash)

      if h.is_a?(Hash)
        # validation: :page is required
        errors << "page is required" if h['page'].nil?

        # validation: :pagesize is required
        errors << "pagesize is required" if h['pagesize'].nil?

        # validation: :sortcolumn is required
        errors << "sortcolumn is required" if h['sortcolumn'].nil?

        # validation: :sortorder is required
        errors << "sortorder is required" if h['sortorder'].nil?

        # validation: the value of :sortcolumn must be a valid string
        errors << "sortcolumn must be a valid string" if !h['sortcolumn'].nil? && !h['sortcolumn'].is_a?(String)

        # validation: the value of :sortorder must be a valid string or nil
        errors << "sortorder must be a valid string" if !h['sortorder'].nil? && !h['sortorder'].is_a?(String)

        # validation: if :sortorder is a string, it must be either 'asc' or 'desc'
        if !h['sortorder'].nil? && h['sortorder'].is_a?(String)
          errors << "sortorder must be either 'asc' or 'desc'" if h['sortorder']!='asc' && h['sortorder']!='desc'
        end

        # validation: the value of :page must be a valid integer or nil
        errors << "page must be a valid integer" if !h['page'].nil? && !h['page'].is_a?(Integer)

        # validation: the value of :pagesize must be a valid integer or nil
        errors << "pagesize must be a valid integer" if !h['pagesize'].nil? && !h['pagesize'].is_a?(Integer)
      end

      errors
    end

    # TODO: move this to a super-module called BlackStack::MySaas::Paginable, as an abstract method.
    # Return the FROM-WHERE part of the SQL query to retrieve the results of the table, with not pagination nor sorting, nor listed columns.
    # This method is used to build custom queries on other methods.
    def core
      q0 = "
        FROM fl_lead l
        WHERE 1=1
      "

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

    # total number of unique leads matching with this search
    # TODO: move this to a super-module called BlackStack::MySaas::Paginable, as an abstract method.
    def count
      DB["SELECT COUNT(id) AS n #{self.core}"].first[:n]
    end

    # TODO: move this to a super-module called BlackStack::MySaas::Paginable 
    # return a hash descriptor with the sattus of the pagination: row_from, row_to, total_rows, total_pages, page (after revision)
    def status(h)
      # validate the pagination descriptor
      errors = self.validate_pagination_descriptor(h)

      # raise an exception if there are errors
      raise "Errors found:\n#{errors.join("\n")}" if errors.size>0

      # get parameters
      page_number = h['page'].to_i
      page_size = h['pagesize'].to_i

      total_rows = self.count
      total_pages = (total_rows.to_f/page_size.to_f).ceil

      # pagination correction to prevent glitches
      page_number = 1 if page_number < 1
      page_number = total_pages if page_number > total_pages

      # calculate info for showing at the bottom of the table
      from_row = (page_number.to_i-1) * page_size.to_i + 1
      to_row = [page_number*page_size, total_rows].min

      # return
      {
        'row_from' => from_row,
        'row_to' => to_row,
        'total_rows' => total_rows,
        'total_pages' => total_pages,
        'page' => page_number
      }
    end


    def self.validate_columns_descriptor(h)
      errors = []

      # validate: h must be a hash
      errors << "columns must be a hash" if !h.is_a?(Hash)

      # other validations
      if h.is_a?(Hash)
        # validattion: :query_field is required
        errors << "query_field is required" if h['query_field'].nil?

        # validation: :query_field must be a string
        errors << "query_field must be a string" if !h['query_field'].nil? && !h['query_field'].is_a?(String)
      end

      # return
      errors
    end


    # TODO: move this to a super-module called BlackStack::MySaas::Paginable as an abstract method
    # return an array of hashes with the columns of the table
    def columns
      [
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

    # TODO: move this to a super-module called BlackStack::MySaas::Paginable
    # return an array of leads, filtering by the parameters of this search, and paginating and sorting by the parameters received.
    def rows(h)
      # validate the pagination descriptor
      errors = self.validate_pagination_descriptor(h)

      # raise an exception if there are errors
      raise "Errors found:\n#{errors.join("\n")}" if errors.size>0

      # get pagination status
      p = self.status(h)

      # get the list of leads
      column_names = self.columns.map {|c| c['query_field'] }
      q = "
        SELECT #{column_names.join(', ')}
        #{self.core}
        -- sorting
        ORDER BY l.#{h['sortcolumn']} #{h['sortorder']}
        -- pagination
        LIMIT #{h['pagesize']}
        OFFSET #{p['row_from']}
      "
      DB[q].all
    end 

    # reurn
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


  end
end
