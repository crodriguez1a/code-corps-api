defmodule CodeCorps.GitHub.Event.IssueComment.CommentDeleterTest do
  @moduledoc false

  use CodeCorps.DbAccessCase

  import CodeCorps.{Factories, GitHubCase.Helpers}

  alias CodeCorps.{
    GitHub.Event.IssueComment.CommentDeleter,
    Repo,
    Comment
  }

  describe "delete_all/1" do
    @payload load_event_fixture("issue_comment_deleted")

    test "deletes all comments with github id specified in the payload" do
      %{"comment" => %{"id" => comment_github_id}} = @payload

      insert_list(2, :comment, github_id: comment_github_id)
      insert_list(3, :comment, github_id: nil)
      insert_list(1, :comment, github_id: 1)

      {:ok, deleted_comments} = CommentDeleter.delete_all(@payload)

      assert Enum.count(deleted_comments) == 2
      assert Repo.aggregate(Comment, :count, :id) == 4
    end
  end
end
