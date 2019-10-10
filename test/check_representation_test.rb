require 'test_helper'
require 'json'

module Orchestrator
  class CheckRepresentationTest < Minitest::Test

    def test_checks_the_database_correctly
      track_slug = "ruby"
      exercise_slug = "bob"
      iteration_id = mock
      status = 'approved'
      comments_data = {"foo" => "bar"}

      correct_representation = "Something complex \n and cool"
      wrong_representation1 = "Something else complex \n and cool"
      wrong_representation2 = "Something other complex \n and cool"

      client = Mysql2.configure_client
      client.query("DELETE FROM fixtures")

      stmt = client.prepare("INSERT INTO fixtures (track_slug, exercise_slug, representation, status, comments_data) VALUES (?, ?, ?, ?, ?)")
      stmt.execute(track_slug, "fred", wrong_representation1, :meh, {}.to_json)
      stmt.execute(track_slug, exercise_slug, correct_representation, status, comments_data.to_json)
      stmt.execute(track_slug, "charlie", wrong_representation2, :hmmm, {}.to_json)

      GenerateRepresentation.expects(:call).with(track_slug, exercise_slug, iteration_id).returns(correct_representation)

      expected = {status: status.to_sym, comments_data: comments_data}
      assert_equal expected, CheckRepresentation.(track_slug, exercise_slug, iteration_id)
    end
  end
end
