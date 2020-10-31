module Games
  module Logic
    class Draw
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
        steps = %i[line diagonal].map do |side|
          send "step_by_#{side}"
        end.flatten

        steps.none? { |s| s == true }
      end

      private

      def step_by_line
        gamers.map do |gamer|
          kind = gamer.kind.to_s

          %i[horizontal vertical].map do |direction|
            line(direction).map do |row|
              row.match(/(n#{kind}{4})|(#{kind}{4}n)|(#{kind}{3}nn)|(nn#{kind}{3})|(#{kind}{2}nnn)|(nnn#{kind}{2})|(#{kind}{1}nnnn)|(nnnn#{kind}{1})/).present? #TODO checkn
            end
          end
        end.flatten
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

      def step_by_diagonal
        gamers.map do |gamer|
          kind = gamer.kind.to_s

          %i[left right].map do |direction|
            diagonal direction, kind
          end
        end.flatten
      end

      def diagonal(direction, kind)
        kind_cells = cells.where(kind: kind)

        kind_cells.each do |cell|
          cells_map = cells.map do |cell|
            {
              x: cell.x,
              y: cell.y,
              kind: kind
            }
          end

          complete = (0..4).map do |inc|
            x = direction == :left ? (cell.x + inc) : (cell.x - inc)

            {
              x: x,
              y: (cell.y + inc),
              kind: (inc == 4 ? nil : kind)
            }
          end

          return true if (complete & cells_map).size >= 5 #TODO final condition
        end

        false
      end
    end
  end
end

