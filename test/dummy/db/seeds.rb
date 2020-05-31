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
      Conference.create! name: 'University of Atlantis 2017', start_date: '2017-04-07',
                         finish_date: '2017-04-09',
                         rooms: Room.where(institution: Institution.i18n.find_by(name: 'University of Atlantis'))
      Conference.create! name: 'University of Shangri-La 2018', start_date: '2018-04-09',
                         finish_date: '2018-04-11',
                         rooms: Room.where(institution: Institution.i18n.find_by(name: 'University of Shangri-La'))
      PresentationType.create! [{
        name: 'Plenary', minutes: 80, conference: Conference.i18n.find_by(name: 'University of Atlantis 2017'),
        room_possessions: RoomPossession.where(
          room: Room.i18n.find_by(building: 'Lecture block', number: '3',
                                  institution: Institution.i18n.find_by(name: 'University of Atlantis')),
          conference: Conference.i18n.find_by(name: 'University of Atlantis 2017')
        )
      }, {
        name: 'Poster', minutes: 30, conference: Conference.i18n.find_by(name: 'University of Atlantis 2017'),
        room_possessions: RoomPossession.where(
          room: Room.i18n.find_by(building: 'Lecture block', number: 'entrance',
                                  institution: Institution.i18n.find_by(name: 'University of Atlantis')),
          conference: Conference.i18n.find_by(name: 'University of Atlantis 2017')
        )
      }, {
        name: 'Talk', minutes: 20, conference: Conference.i18n.find_by(name: 'University of Atlantis 2017'),
        room_possessions: RoomPossession.where(
          room: Room.i18n.find_by(building: 'Lecture block', number: %w[2 3],
                                  institution: Institution.i18n.find_by(name: 'University of Atlantis')),
          conference: Conference.i18n.find_by(name: 'University of Atlantis 2017')
        )
      }, {
        name: 'Plenary', minutes: 80, conference: Conference.i18n.find_by(name: 'University of Shangri-La 2018'),
        room_possessions: RoomPossession.where(
          room: Room.i18n.find_by(building: 'Medical school', number: 'G.152',
                                  institution: Institution.i18n.find_by(name: 'University of Shangri-La')),
          conference: Conference.i18n.find_by(name: 'University of Shangri-La 2018')
        )
      }, {
        name: 'Poster', minutes: 30, conference: Conference.i18n.find_by(name: 'University of Shangri-La 2018'),
        room_possessions: RoomPossession.where(
          room: Room.i18n.find_by(building: 'Medical school', number: 'G.14',
                                  institution: Institution.i18n.find_by(name: 'University of Shangri-La')),
          conference: Conference.i18n.find_by(name: 'University of Shangri-La 2018')
        )
      }, {
        name: 'Talk', minutes: 20, conference: Conference.i18n.find_by(name: 'University of Shangri-La 2018'),
        room_possessions: RoomPossession.where(
          room: Room.i18n.find_by(building: 'Medical school', number: %w[G.152 G.16],
                                  institution: Institution.i18n.find_by(name: 'University of Shangri-La')),
          conference: Conference.i18n.find_by(name: 'University of Shangri-La 2018')
        )
      }]
      Delegate.create! first_name: 'Joe', last_name: 'Bloggs', email_address: 'someone@someaddress.com',
                       institution: Institution.i18n.find_by(name: 'University of Atlantis'),
                       dietary_requirements: [DietaryRequirement.new(name: 'Pescetarian')],
                       conferences: Conference.i18n.where(name: ['University of Atlantis 2017', 'University of Shangri-La 2018'])
      Presentation.create! title: 'The Asymmetry and Antisymmetry of Syntax', date: '2017-04-07', start_time: '10:00',
                           abstract: 'Lorem ipsum', presenters: Delegate.where(first_name: 'Joe', last_name: 'Bloggs'),
                           room_use: RoomUse.find_by(
                             room_possession:
                               RoomPossession.where(room: Room.i18n.where(building: 'Lecture block', number: '2',
                                                                          institution:
                                                                            Institution.i18n.find_by(name: 'University of Atlantis')),
                                                    conference: Conference.i18n.find_by(name: 'University of Atlantis 2017')),
                             presentation_type:
                               PresentationType.i18n.where(name: 'Talk', conference:
                                Conference.i18n.find_by(name: 'University of Atlantis 2017'))
                           )
    end
  end
end
