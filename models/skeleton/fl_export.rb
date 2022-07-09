module Leads
  class FlExport < Sequel::Model(:fl_export)
    many_to_one :user, :class=>:'BlackStack::MySaaS::User', :key=>:id_user
    many_to_one :fl_search, :class=>:'Leads::FlSearch', :key=>:id_search

=begin
    # constructor
    def initialize(h)
      super()
      errors = Leads::FlExport.validate_descriptor(h)
      raise "Errors found:\n#{errors.join("\n")}" if errors.size>0
      # map the hash to the attributes of the model.
      self.id = guid
      self.create_time = now
    end

    # validate the strucutre of the hash descritpor.
    # return an arrow of strings with the errors found.
    def self.validate_descriptor(h)
      errors = []

      # validate: h must be a hash
      errors << "Descriptor must be a hash" if !h.is_a?(Hash)

      # return the errors found.
      errors
    end
=end
  end
end
