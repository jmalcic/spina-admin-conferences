# frozen_string_literal: true

module Spina
  module Admin
    module Conferences
      # This class manages presentations and sets breadcrumbs
      class PresentationsController < ::Spina::Admin::AdminController
        include ::Spina::Conferences
        include Importable

        before_action :set_breadcrumbs
        before_action :set_tabs, only: %i[new create edit update]

        def index
          @presentations = params[:room_id] ? Room.find(params[:room_id]).presentations.sorted : Presentation.sorted
        end

        def new
          @presentation = params[:presentation] ? Presentation.new(presentation_params) : Presentation.new
          add_breadcrumb I18n.t('spina.conferences.presentations.new')
          render layout: 'spina/admin/admin'
        end

        def edit
          @presentation = Presentation.find params[:id]
          add_breadcrumb @presentation.title
          render layout: 'spina/admin/admin'
        end

        def create
          @presentation = Presentation.new presentation_params
          add_breadcrumb I18n.t('spina.conferences.presentations.new')
          if @presentation.save
            redirect_to admin_conferences_presentations_path
          else
            render :new, layout: 'spina/admin/admin'
          end
        end

        def update
          @presentation = Presentation.find params[:id]
          add_breadcrumb @presentation.title
          if @presentation.update(presentation_params)
            redirect_to admin_conferences_presentations_path
          else
            render :edit, layout: 'spina/admin/admin'
          end
        end

        def destroy
          @presentation = Presentation.find params[:id]
          @presentation.destroy
          redirect_to admin_conferences_presentations_path
        end

        def import
          @presentations = import_csv(params[:file]).collect do |row|
            conference = Conference.where(
              institution: Institution.find_by(name: row[:conference_institution], city: row[:conference_city])
            ).find_by(['dates @> ?::date', row[:date]])
            room_use = RoomUse.find_by(
              presentation_type: PresentationType.find_by(conference: conference, name: row[:presentation_type]),
              room_possession: RoomPossession.find_by(
                conference: conference,
                room: Room.find_by(building: row[:building], number: row[:room])
              )
            )
            presenters =
              row[:presenters].split(';').collect do |presenter_names|
                delegate = Delegate.find_or_initialize_by(
                  first_name: presenter_names.split(',')[1],
                  last_name: presenter_names.split(',')[0],
                  institution:
                    Institution.find_or_initialize_by(name: row[:institution_name], city: row[:institution_city])
                )
                delegate.conferences << conference if delegate && conference
                delegate.save
                delegate
              end
            params[:presentation] = {
              title: row[:title],
              date: row[:date],
              start_time: row[:start_time],
              abstract: row[:abstract],
              room_use_id: room_use&.id,
              presenter_ids: presenters.map(&:id)
            }
            Presentation.new presentation_params
          end
          Presentation.transaction do
            @presentations.each(&:save!)
          rescue ActiveRecord::RecordInvalid => error
            @presentations = Presentation.sorted
            flash.now[:alert] = error.message
            render :index
          end
        end

        private

        def set_breadcrumbs
          add_breadcrumb I18n.t('spina.conferences.website.presentations'),
                         admin_conferences_presentations_path
        end

        def set_tabs
          @tabs = %w[presentation_details presenters]
        end

        def presentation_params
          params.require(:presentation).permit(:title, :date, :start_time, :abstract, :room_use_id, presenter_ids: [])
        end
      end
    end
  end
end
