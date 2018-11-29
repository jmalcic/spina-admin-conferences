# frozen_string_literal: true

module Spina
  module Admin
    module Conferences
      # This class manages presentations and sets breadcrumbs
      class PresentationsController < AdminController
        include Importable

        before_action :set_breadcrumbs
        before_action :set_tabs, only: %i[new create edit update]

        def index
          @presentations =
            if params[:room_id]
              Spina::Conferences::Room.find(params[:room_id])
                                      .presentations.sorted
            else
              Spina::Conferences::Presentation.sorted
            end
        end

        def new
          @presentation = Spina::Conferences::Presentation.new
          add_breadcrumb I18n.t('spina.conferences.presentations.new')
          render layout: 'spina/admin/admin'
        end

        def edit
          @presentation = Spina::Conferences::Presentation.find params[:id]
          add_breadcrumb @presentation.title
          render layout: 'spina/admin/admin'
        end

        def create
          @presentation =
            Spina::Conferences::Presentation.new presentation_params
          add_breadcrumb I18n.t('spina.conferences.presentations.new')
          if @presentation.save
            redirect_to admin_conferences_presentations_path
          else
            render :new, layout: 'spina/admin/admin'
          end
        end

        def update
          @presentation = Spina::Conferences::Presentation.find params[:id]
          add_breadcrumb @presentation.title
          if @presentation.update(presentation_params)
            redirect_to admin_conferences_presentations_path
          else
            render :edit, layout: 'spina/admin/admin'
          end
        end

        def destroy
          @presentation = Spina::Conferences::Presentation.find params[:id]
          @presentation.destroy
          redirect_to admin_conferences_presentation_types_path
        end

        def import
          @presentations = import_csv(params[:file]).collect do |row|
            conference = Spina::Conferences::Conference.where(
              institution: Spina::Conferences::Institution.find_by(
                name: row[:conference_institution], city: row[:conference_city]
              )
            ).find_by(['dates @> ?::date', row[:date]])
            room_use = Spina::Conferences::RoomUse.find_by(
              presentation_type:
                Spina::Conferences::PresentationType.find_by(
                  conference: conference,
                  name: row[:presentation_type]
                ),
              room_possession: Spina::Conferences::RoomPossession.find_by(
                conference: conference,
                room: Spina::Conferences::Room.find_by(
                  building: row[:building],
                  number: row[:room]
                )
              )
            )
            presenters =
              row[:presenters].split(';').collect do |presenter_names|
                delegate = Spina::Conferences::Delegate.find_or_initialize_by(
                  first_name: presenter_names.split(',')[1],
                  last_name: presenter_names.split(',')[0],
                  institution:
                    Spina::Conferences::Institution.find_or_initialize_by(
                      name: row[:institution_name],
                      city: row[:institution_city]
                    )
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
            Spina::Conferences::Presentation.new presentation_params
          end
          Spina::Conferences::Presentation.transaction do
            @presentations.each(&:save!)
          rescue ActiveRecord::RecordInvalid => error
            @presentations = Spina::Conferences::Presentation.sorted
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
          params.require(:presentation).permit(:title, :date, :start_time,
                                               :abstract, :room_use_id,
                                               presenter_ids: [])
        end
      end
    end
  end
end
