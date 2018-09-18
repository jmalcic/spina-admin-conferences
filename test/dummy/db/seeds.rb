# frozen_string_literal: true

module Spina
  Account.first_or_create name: 'Collect', theme: 'conference'
  User.first_or_create name: 'Justin', email: 'j.malcic@me.com',
                       password: 'password', admin: true
  module Collect
    Institution.create name: 'University of Cambridge', city: 'Cambridge'
    Institution.create name: 'University of Edinburgh', city: 'Edinburgh'
    Room.create institution_id: 1, building: 'Lecture block', number: '2'
    Room.create institution_id: 1, building: 'Lecture block', number: '3'
    Room.create institution_id: 1, building: 'Lecture block', number: 'entrance'
    Room.create institution_id: 2, building: 'Medical school', number: 'G.14'
    Room.create institution_id: 2, building: 'Medical school', number: 'G.152'
    Room.create institution_id: 2, building: 'Medical school', number: 'G.16'
    Conference.create institution_id: 1, start_date: '2017-04-07',
                      finish_date: '2017-04-09'
    Conference.create institution_id: 2, start_date: '2018-04-09',
                      finish_date: '2018-04-11'
    PresentationType.create conference_id: 1, name: 'Plenary', minutes: 80,
                            room_possession_ids: [2]
    PresentationType.create conference_id: 1, name: 'Poster', minutes: 30,
                            room_possession_ids: [3]
    PresentationType.create conference_id: 1, name: 'Oral', minutes: 20,
                            room_possession_ids: [1, 2]
    PresentationType.create conference_id: 2, name: 'Plenary', minutes: 80,
                            room_possession_ids: [5]
    PresentationType.create conference_id: 2, name: 'Poster', minutes: 30,
                            room_possession_ids: [4]
    PresentationType.create conference_id: 2, name: 'Oral', minutes: 20,
                            room_possession_ids: [5, 6]
    DietaryRequirement.create name: 'Pescetarian'
    Delegate.create first_name: 'Justin', last_name: 'Malčić',
                    institution_id: 1, email_address: 'j.malcic@me.com',
                    conference_ids: [1, 2], dietary_requirement_ids: 1
    Presentation.create title: 'The Asymmetry and Antisymmetry of Syntax',
                        room_use_id: 3, date: '2017-04-07', start_time: '10:00',
                        abstract: 'Lorem ipsum', presenter_ids: [1]
  end
end
