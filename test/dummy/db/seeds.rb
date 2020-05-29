# frozen_string_literal: true

module Spina
  Account.first_or_create name: 'Conferences', theme: 'default'
  User.first_or_create name: 'Joe', email: 'someone@someaddress.com', password: 'password', admin: true
  module Admin
    module Conferences
      Institution.create! name: 'University of Atlantis', city: 'Atlantis',
                          rooms: [Room.new(building: 'Lecture block', number: '2'),
                                  Room.new(building: 'Lecture block', number: '3'),
                                  Room.new(building: 'Lecture block', number: 'entrance')]
      Institution.create! name: 'University of Shangri-La', city: 'Shangri-La',
                          rooms: [Room.new(building: 'Medical school', number: 'G.14'),
                                  Room.new(building: 'Medical school', number: 'G.152'),
                                  Room.new(building: 'Medical school', number: 'G.16')]
      Conference.create! institution: Institution.find_by(name: 'University of Atlantis'), start_date: '2017-04-07',
                         finish_date: '2017-04-09',
                         rooms: Room.includes(:institution)
                                    .where(spina_conferences_institutions: { name: 'University of Atlantis' })
      Conference.create! institution: Institution.find_by(name: 'University of Shangri-La'), start_date: '2018-04-09',
                         finish_date: '2018-04-11',
                         rooms: Room.includes(:institution)
                                    .where(spina_conferences_institutions: { name: 'University of Shangri-La' })
      PresentationType.create! [{
        name: 'Plenary', minutes: 80, conference: Conference.includes(:institution).find_by(
          spina_conferences_institutions: { name: 'University of Atlantis' }
        ), room_possessions: RoomPossession.includes(:room, :institution).where(
          spina_conferences_institutions: { name: 'University of Atlantis' },
          spina_conferences_rooms: { building: 'Lecture block', number: '3' }
        )
      }, {
        name: 'Poster', minutes: 30, conference: Conference.includes(:institution).find_by(
          spina_conferences_institutions: { name: 'University of Atlantis' }
        ), room_possessions: RoomPossession.includes(:room, :institution).where(
          spina_conferences_institutions: { name: 'University of Atlantis' },
          spina_conferences_rooms: { building: 'Lecture block', number: 'entrance' }
        )
      }, {
        name: 'Talk', minutes: 20, conference: Conference.includes(:institution).find_by(
          spina_conferences_institutions: { name: 'University of Atlantis' }
        ), room_possessions: RoomPossession.includes(:room, :institution).where(
          spina_conferences_institutions: { name: 'University of Atlantis' },
          spina_conferences_rooms: { building: 'Lecture block', number: %w[2 3] }
        )
      }, {
        name: 'Plenary', minutes: 80, conference: Conference.includes(:institution).find_by(
          spina_conferences_institutions: { name: 'University of Shangri-La' }
        ), room_possessions: RoomPossession.includes(:room, :institution).where(
          spina_conferences_institutions: { name: 'University of Shangri-La' },
          spina_conferences_rooms: { building: 'Medical school', number: 'G.152' }
        )
      }, {
        name: 'Poster', minutes: 30, conference: Conference.includes(:institution).find_by(
          spina_conferences_institutions: { name: 'University of Shangri-La' }
        ), room_possessions: RoomPossession.includes(:room, :institution).where(
          spina_conferences_institutions: { name: 'University of Shangri-La' },
          spina_conferences_rooms: { building: 'Medical school', number: 'G.14' }
        )
      }, {
        name: 'Talk', minutes: 20, conference: Conference.includes(:institution).find_by(
          spina_conferences_institutions: { name: 'University of Shangri-La' }
        ), room_possessions: RoomPossession.includes(:room, :institution).where(
          spina_conferences_institutions: { name: 'University of Shangri-La' },
          spina_conferences_rooms: { building: 'Medical school', number: %w[G.152 G.16] }
        )
      }]
      Delegate.create! first_name: 'Joe', last_name: 'Bloggs', email_address: 'someone@someaddress.com',
                       institution: Institution.find_by(name: 'University of Atlantis'),
                       dietary_requirements: [DietaryRequirement.new(name: 'Pescetarian')],
                       conferences: Conference.includes(:institution).where(
                         spina_conferences_institutions: { name: ['University of Atlantis', 'University of Shangri-La'] }
                       )
      Presentation.create! title: 'The Asymmetry and Antisymmetry of Syntax', date: '2017-04-07', start_time: '10:00',
                           abstract: 'Lorem ipsum', presenters: Delegate.where(first_name: 'Joe', last_name: 'Bloggs'),
                           room_use: RoomUse.includes(:room, :presentation_type, :institution).find_by(
                             spina_conferences_rooms: { building: 'Lecture block', number: '2' },
                             spina_conferences_presentation_types: { name: 'Talk' },
                             spina_conferences_institutions: { name: 'University of Atlantis' }
                           )
    end
  end
end
