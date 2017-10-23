module HitsCounter
  class HcMatchingHitsController < ApplicationController
    def index
      if hc_logged_in?
        hits = HitsCounter::HcMatchingHit.order("match_to asc").order("DATE(created_at) desc").group("match_to", "DATE(created_at)").count
        @hits = hits.map { |r, c| [r.first, c, r.last] }.unshift(['URL pattern', 'Visits count', 'Date'])

        respond_to do |format|
          format.html { render "hits_counter/hits_report" }
          format.csv { send_data HitsCounter.to_csv(@hits) }
        end
      else
        render "hits_counter/login"
      end
    end
  end
end
