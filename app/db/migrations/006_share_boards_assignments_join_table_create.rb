# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_join_table(share_board_id: :share_boards, assignment_id: :assignments)
  end
end
