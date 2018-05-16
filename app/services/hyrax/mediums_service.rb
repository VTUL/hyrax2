module Hyrax
  module MediumsService
    mattr_accessor :authority
    self.authority = ControlledVocab.where(field: 'medium_sim')
  
    def self.select_all_options
      authority.all.map do |element|
        [element[:name], element[:name]]
      end
    end

    def self.label(id)
      authority.find(id).fetch('name')
    end
  end
end
