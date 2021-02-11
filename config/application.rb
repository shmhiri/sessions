require_relative "boot"

require "rails/all"
require 'zoomus'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Sessions
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end

module Zoom
  class Meeting
    attr_reader :start_time, :topic, :duration, :timezone, :id, :type, :join_url

    def initialize(attributes = {})
      attributes.each { |name, value| instance_variable_set("@#{name}", value) }
    end
  end


class MeetingService

    def update(meeting_params)
      begin
        zoomus_client.meeting_update(merge_params(meeting_params))
      rescue Exception => e
        { error: e.message }
      end
    end

    def create(meeting_params)
      begin
        zoomus_client.meeting_create(merge_params(meeting_params))
      rescue Exception => e
        { error: e.message }
      end
    end

    def get_all
      begin
        meetings = zoomus_client.meeting_list(host_id: user_id)['meetings']
        meetings.map do |obj|
          Zoom::Meeting.new(obj)
        end
      rescue Exception => e
      end
    end

    def get_by_id(id)
      Zoom::Meeting.new(zoomus_client.meeting_get({ host_id: user_id, id: id }))
    end

    def delete(id)
      zoomus_client.meeting_delete({ host_id: user_id, id: id })
    end

    private
    def zoomus_client
      @instance ||= Zoomus.new
    end

    def merge_params(params)
      params.merge({
        host_id: user_id,
        start_time: process_meeting_date(params['start_time'])
      })
    end

    def process_meeting_date(the_date)
      Time.parse(the_date).strftime("%Y-%m-%dT%H:%M:%SZ") if the_date.present?
    end

    def user_id
      @user ||= zoomus_client.user_getbyemail(email: ENV['@user_getbyemail'])['id']
    end
  end

end


end
