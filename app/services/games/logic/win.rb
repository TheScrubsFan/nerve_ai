module Games
  module Logic
    class Win
      attr_accessor :game, :gamers, :cells

      class << self
        def perform(params)
          new(params).perform
        end
      end

      def initialize(game)
        @game = game
        @gamers = game.gamers.where.not(kind: nil)
        @cells = game.cells
      end

      def perform
        %i[horizontal vertical].each do |type|
          winner = winner_in_line type

          return winner if winner
        end

        %i[left right].each do |type|
          winner = winner_in_diagonal type

          return winner if winner
        end

        return nil
      end

      private

      def winner_in_line(board_type)
        board = send board_type

        gamers.detect do |gamer|
          kind = gamer.kind.to_s
          win = board.map do |row|
            gamer if row.match(/#{kind}{5}/).present?
          end

          win.any?
        end
      end

      def horizontal
        [].tap do |array|
          (1..game.dimension).each do |y|
            array << cells.where(y: y).order('x ASC').map{|c| c.kind? ? c.kind : 'n'}.join('')
          end
        end
      end

      def vertical
        [].tap do |array|
          (1..game.dimension).each do |x|
            array << cells.where(x: x).order('y ASC').map{|c| c.kind? ? c.kind : 'n'}.join('')
          end
        end
      end

      def winner_in_diagonal(direction)
        gamers.detect do |gamer|
          kind = gamer.kind.to_s

          send(direction, kind)
        end
      end

      def left(kind)
        kind_cells = cells.where(kind: kind)

        kind_cells.each do |cell|
          cells_map = kind_cells.map do |cell|
            {
              x: cell.x,
              y: cell.y
            }
          end

          complete = (0..4).map do |inc|
            {
              x: (cell.x + inc),
              y: (cell.y + inc)
            }
          end

          return true if (complete & cells_map).size >= 5
        end

        false
      end

      def right(kind)
        kind_cells = cells.where(kind: kind)

        kind_cells.each do |cell|
          cells_map = kind_cells.map do |cell|
            {
              x: cell.x,
              y: cell.y
            }
          end

          complete = (0..4).map do |inc|
            {
              x: (cell.x - inc),
              y: (cell.y + inc)
            }
          end

          return true if (complete & cells_map).size >= 5
        end

        false
      end

      def array_increments?(array)
        return false unless array.size < 5

        sorted = array.sort_by(&:x)
        last_cell = sorted.first

        sorted[1, sorted.count].each do |cell|
          if last_cell.x + 1 != cell.x &&
              last_cell.y + 1 != cell.y
            return false
          end

          last_cell = cell
        end

        true
      end
    end
  end
end
