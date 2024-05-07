module Appointment
  class SendToGoogleCalendar < ApplicationJob
    def perform(appointment_id)
      appointment = Repository.find_by(id: appointment_id)

      token = Token::Repository.fetch_by(provider: "google", user_id: appointment.user_id)


      service = Google::Apis::CalendarV3::CalendarService.new

      service.authorization = token.google_secret.to_authorization


      if token.expired?
        new_access_token = service.authorization.refresh!
        token.access_token = new_access_token["access_token"]

        now = Time.zone.now.to_i
        token.expires_at = new_access_token["expires_in"].to_i + now

        Token::Repository.upsert(token.to_h)
      end

      service.insert_event("primary", event(appointment:))
    end

    private

    def event(appointment:)
      # All the events will have one hour of duration, we are using date to have the time that the event will be scheduled
      custom_event = Google::Apis::CalendarV3::Event.new(
        summary: appointment.name,
        description: appointment.reason,
        start: Google::Apis::CalendarV3::EventDateTime.new(
          date_time: appointment.scheduled_at.to_datetime.rfc3339,
          time_zone: "America/Sao_Paulo"
        ),
        end: Google::Apis::CalendarV3::EventDateTime.new(
          date_time: (appointment.scheduled_at + 1.hour).to_datetime.rfc3339,
          time_zone: "America/Sao_Paulo"
        )
      )

      custom_event
    end
  end
end
