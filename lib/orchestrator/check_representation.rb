module Orchestrator
  class CheckRepresentation
    include Mandate

    initialize_with :track_slug, :exercise_slug, :iteration_id

    def call
      representation = GenerateRepresentation.(track_slug, exercise_slug, iteration_id)

      stmt = mysql_client.prepare("SELECT * FROM fixtures WHERE track_slug = ? and exercise_slug = ? and representation = ?")
      results = stmt.execute(track_slug, exercise_slug, representation)
      return nil if results.count == 0

      result = results.first
      {
        status: result["status"].to_sym,
        comments_data: JSON.parse(result["comments_data"])
      }
    end

    private

    memoize
    def mysql_client
      Mysql2.configure_client
    end
  end
end
