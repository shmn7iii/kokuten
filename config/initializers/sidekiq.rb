# frozen_string_literal: true

Sidekiq.configure_server do |config|
  config.on(:startup) do
    schedule_file = "config/sidekiq_schedule.yml"

    if File.exist?(schedule_file)
      Sidekiq::Cron::Job.load_from_hash YAML.load_file(schedule_file)
    end
  end
end
