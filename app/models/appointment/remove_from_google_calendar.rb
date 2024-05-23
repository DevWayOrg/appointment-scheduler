module Appointment
  class RemoveFromGoogleCalendar < ApplicationJob
    def perform(google_calendar_id, user_id)

      token = Token::Repository.fetch_by(provider: "google", user_id: user_id)


      service = Google::Apis::CalendarV3::CalendarService.new

      service.authorization = token.google_secret.to_authorization


      if token.expired?
        new_access_token = service.authorization.refresh!
        token.access_token = new_access_token["access_token"]

        now = Time.zone.now.to_i
        token.expires_at = new_access_token["expires_in"].to_i + now

        Token::Repository.upsert(token.to_h)
      end

      service.delete_event("primary", google_calendar_id)
    end
  end
end
