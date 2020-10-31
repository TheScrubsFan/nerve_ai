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
        %i[line diagonal].each do |side|
          winner = send "winner_in_#{side}"

          return winner if winner
        end

        return nil
      end

      private

      def winner_in_line
        gamers.detect do |gamer|
          kind = gamer.kind.to_s

          %i[horizontal vertical].map do |direction|
            line(direction).map do |row|
              gamer if row.match(/#{kind}{5}/).present?
            end
          end.flatten.any?
        end
      end

      def line(direction)
        [].tap do |array|
          (1..game.dimension).each do |y|
            stack = if direction == :horizontal
              cells.where(y: y).order('x ASC')
            else
              cells.where(x: y).order('y ASC')
            end

            array << stack.map{|c| c.kind? ? c.kind : 'n'}.join('')
          end
        end
      end

      def winner_in_diagonal
        gamers.detect do |gamer|
          kind = gamer.kind.to_s

          %i[left right].map do |direction|
            diagonal direction, kind
          end.any?
        end
      end

      def diagonal(direction, kind)
        kind_cells = cells.where(kind: kind)

        kind_cells.each do |cell|
          cells_map = kind_cells.map do |cell|
            {
              x: cell.x,
              y: cell.y
            }
          end

          complete = (0..4).map do |inc|
            x = direction == :left ? (cell.x + inc) : (cell.x - inc)

            {
              x: x,
              y: (cell.y + inc)
            }
          end

          return true if (complete & cells_map).size >= 5
        end

        false
      end
    end
  end
end
