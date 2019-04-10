# frozen_string_literal: true

require 'resque/server'

Rails.application.routes.draw do
  mount Spina::Engine => '/'
  mount Resque::Server => '/jobs'
end
