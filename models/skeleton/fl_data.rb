module Leads
  class FlData < Sequel::Model(:fl_data)
    many_to_one :fl_lead, :class=>:'Leads::FlLead', :key=>:id_lead

    TYPE_PHONE = 10
    TYPE_EMAIL = 20

    # return an array of possibly valid types.
    def self.types
      [
        Leads::FlData::TYPE_PHONE,
        Leads::FlData::TYPE_EMAIL,
      ]
    end

    # return a descriptive name for each one.
    # if `n` is an unknown value, then reutrn nil.
    def self.type_name(n)
      if n == Leads::FlData::TYPE_PHONE
        'Phone'
      elsif n == Leads::FlData::TYPE_EMAIL
        'Email'
      else
        nil
      end
    end

    # validate the format of the value `v`, depending on the type `t`.
    def self.validate_value(t, v)
      if t == Leads::FlData::TYPE_PHONE
        # we are not validating the format of the phone number by now, because phone numbers are not regular, so there is not a regular expression to validate them.
        return true
      elsif t == Leads::FlData::TYPE_EMAIL
        # validate the format of the email.
        return v.to_s.email?
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
      errors << "Descriptor :data must have :type" if h.is_a?(Hash) && !h.has_key?(:type)

      # validate: if h is a hash, and it has a :type key, then it must have a valid value.
      if h.is_a?(Hash) && h.has_key?(:type)
        if !Leads::FlData.types.include?(h[:type])
          errors << "Descriptor :data :type #{h[:type]} not valid"
        end
      end

      # validate: if h is a hash, and it must have a :value
      errors << "Descriptor :data must have :value" if h.is_a?(Hash) && !h.has_key?(:value)

      # validate: if h is a hash, and it has a :value, then the :value must be a string.
      if h.is_a?(Hash) && h.has_key?(:value)
        if !h[:value].is_a?(String)
          errors << "Descriptor :data :value must be a string"
        end
      end

      # validate: if h is a hash, and it has a :type, and it has a :value, then the :value must valid
      if h.is_a?(Hash) && h.has_key?(:type) && h.has_key?(:value)
        if !Leads::FlData.validate_value(h[:type], h[:value])
          errors << "Descriptor :data :value #{h[:value]} not valid"
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
      self.type = h[:type]
      self.value = h[:value]
    end

    # return a hash descriptor for the data.
    def to_h
      {
        :type => self.type,
        :value => self.value,
      }
    end
  end
end
