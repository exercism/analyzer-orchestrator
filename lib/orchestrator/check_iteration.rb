module Orchestrator

  class CheckIteration
    include Mandate

    initialize_with :track_slug, :exercise_slug, :iteration_id

    def call
      results = AnalyzeIteration.(
        track_slug,
        exercise_slug,
        iteration_id,
        CheckRepresentation.(track_slug, exercise_slug, iteration_id)
      )

      if results && !results.empty?
        propono.publish(:iteration_representation_analyzed, {
          iteration_id: iteration_id,
          status: :success,
          analysis: results
        })
      else
       propono.publish( :iteration_representation_analyzed, {
          iteration_id: iteration_id,
          status: :fail
        })
      end
    end

    private

    memoize
    def propono
      Propono.configure_client
    end
  end
end
