module Leads
  class FlData < Sequel::Model(:fl_data)
    many_to_one :fl_lead, :class=>:'Leads::FlLead', :key=>:id_lead

    MATCH_LINKEDIN_USER_URL = /((https?:\/\/)?(www\.)?linkedin\.com\/in\/)(([-A-Za-z0-9\%](\/?))+$)/

    TYPE_PHONE = 10
    TYPE_EMAIL = 20
    TYPE_LINKEDIN = 90

    # return an array of possibly valid types.
    def self.types
      [
        Leads::FlData::TYPE_PHONE,
        Leads::FlData::TYPE_EMAIL,
        Leads::FlData::TYPE_LINKEDIN,
      ]
    end

    # return a descriptive name for each one.
    # if `n` is an unknown value, then reutrn nil.
    def self.type_name(n)
      if n == Leads::FlData::TYPE_PHONE
        'Phone'
      elsif n == Leads::FlData::TYPE_EMAIL
        'Email'
      elsif n == Leads::FlData::TYPE_LINKEDIN
        'LinkedIn'
      else
        nil
      end
    end

    # return a descripive name for the type of this object
    def type_name
      Leads::FlData.type_name(self.type)
    end

    # validate the format of the value `v`, depending on the type `t`.
    def self.validate_value(t, v)
      if t == Leads::FlData::TYPE_PHONE
        # we are not validating the format of the phone number by now, because phone numbers are not regular, so there is not a regular expression to validate them.
        return true
      elsif t == Leads::FlData::TYPE_EMAIL
        # validate the format of the email.
        return v.to_s.email?
      elsif t == Leads::FlData::TYPE_LINKEDIN
        # remove query string from the url.
        # refernece: https://stackoverflow.com/questions/10410523/removing-a-part-of-a-url-with-ruby
        parsed = URI::parse(v)
        parsed.fragment = parsed.query = nil
        # validate the format of the linkedin url.
        return parsed.to_s =~ MATCH_LINKEDIN_USER_URL
      else
        false
      end
    end

    # validate the strucutre of the hash descritpor.
    # return an arrow of strings with the errors found. 
    def self.validate_descriptor(h)
      errors = []

      # validate: h must be a hash
      errors << "Descriptor must be a hash" if !h.is_a?(Hash)

      # validate: if h is a hash, then it must have :type
      errors << "Descriptor :data must have :type" if h.is_a?(Hash) && !h.has_key?('type')

      # validate: if h is a hash, and it has a :type key, then it must have a valid value.
      if h.is_a?(Hash) && h.has_key?('type')
        if !Leads::FlData.types.include?(h['type'])
          errors << "Descriptor :data :type #{h['type']} not valid"
        end
      end

      # validate: if h is a hash, and it must have a :value
      errors << "Descriptor :data must have :value" if h.is_a?(Hash) && !h.has_key?('value')

      # validate: if h is a hash, and it has a :value, then the :value must be a string.
      if h.is_a?(Hash) && h.has_key?('value')
        if !h['value'].is_a?(String)
          errors << "Descriptor :data :value must be a string"
        end
      end

      # validate: if h is a hash, and it has a :type, and it has a :value, then the :value must valid
      if h.is_a?(Hash) && h.has_key?('type') && h.has_key?('value')
        if !Leads::FlData.validate_value(h['type'], h['value'])
          errors << "Descriptor :data :value #{h['value']} not valid"
        end
      end
      
      # return the errors found.
      errors
    end

    # constructor
    def initialize(h)
      super()
      errors = Leads::FlData.validate_descriptor(h)
      raise "Errors found:\n#{errors.join("\n")}" if errors.size>0
      # map the hash to the attributes of the model.
      self.id = guid
      self.type = h['type']
      if self.type == Leads::FlData::TYPE_LINKEDIN
        # remove query string from the url.
        # refernece: https://stackoverflow.com/questions/10410523/removing-a-part-of-a-url-with-ruby
        parsed = URI::parse(h['value'])
        parsed.fragment = parsed.query = nil
        self.value = parsed.to_s
      else
        self.value = h['value']
      end
    end

    # return a hash descriptor for the data.
    def to_hash
      {
        'type' => self.type,
        'value' => self.value,
      }
    end
  end
end
