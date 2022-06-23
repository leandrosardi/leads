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

  end
end
