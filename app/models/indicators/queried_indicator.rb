module Indicators
  class QueriedIndicator < AbstractIndicator
    attr_accessor :queries

    def facet_name
      name
    end

    def query(sunspot, user)
      this = self
      sunspot.instance_eval do
        with(:owned_by, user.user_name) if this.scope_to_owner
        this.scope&.each { |f| f.query_scope(self) }
        facet(this.facet_name, zeros: true) do
          row(this.name) do
            this.queries.each { |f| f.query_scope(self) }
          end
        end
      end
    end

    def stat_query_strings(_, owner)
      scope_query_strings +
        owner_query_string(owner) +
        (queries&.map(&:to_s) || [])
    end

  end
end