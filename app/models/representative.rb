# frozen_string_literal: true

class Representative < ApplicationRecord
  has_many :news_items, dependent: :delete_all

  def self.civic_api_to_representative_params(rep_info)
    reps = []

    rep_info.officials.each_with_index do |official, index|
      ocdid_temp = ''
      title_temp = ''

      rep_info.offices.each do |office|
        if office.official_indices.include? index
          title_temp = office.name
          ocdid_temp = office.division_id
        end
      end
      
      print(official.address ? official.address[0].line1 : 'NOT')
      # ? check if rep exists
      existing_rep = Representative.find_by(name: official.name)

      # byebug 
      
      if(existing_rep)
        existing_rep.update!({ ocdid: ocdid_temp, title: title_temp,
        street: official.address ? official.address[0].line1 : 'TBD',
        city: official.address ? official.address[0].city : 'TBD', state: official.address ? official.address[0].state : 'TBD', zip: official.address ? official.address[0].zip : 'TBD',
        party: official.party, photo: official.urls[0] })
        reps.push(existing_rep)
      else
        # ? update representative : add address[0], party & photo
        rep = Representative.create!({ name: official.name, ocdid: ocdid_temp,
            title: title_temp, street: official.address ? official.address[0].line1 : 'TBD',
            city: official.address ? official.address[0].city : 'TBD', state: official.address ? official.address[0].state : 'TBD', zip: official.address ? official.address[0].zip : 'TBD',
            party: official.party, photo: official.urls[0] })
        reps.push(rep)
      end
    end

    reps
  end
end
