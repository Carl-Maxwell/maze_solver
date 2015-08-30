require 'colorize'

class Maze
  attr_accessor :rows
  attr_reader :memory, :height, :width

  def initialize(filename, memory)
    @rows = open_file(filename)
    @memory = memory
    @height = @rows.length
    @width = @rows[0].length
  end

  def open_file(filename)
    [].tap do |map|
      File.open(filename) do |f|
        until f.eof?
          map << MazeRow.new( f.gets.chars.map do |tile|
            if tile == " "
              true
            elsif tile == "S"
              # start
            elsif tile == "E"
              # goal
            end
          end )
        end
      end
    end
  end

  def [](row)
    rows[row]
  end

  def at(coord)
    row, col = *coord
    self[row][col]
  end

  def to_s(special_characters = {})
    lines = rows.map(&:to_s)
    lines = lines.map.with_index do |row, row_index|
      row.split("").map.with_index do |col, col_index|
        if special_characters.include?([row_index, col_index])
          special_characters[[row_index, col_index]]
        else
          memory[row_index][col_index] ? col.on_red : col.light_black
        end
      end.join("")
    end
    lines.join("\n")
  end

  def to_a
    rows.map(&:to_a)
  end

  class MazeRow
    #private
    attr_accessor :row

    #public
    def initialize(row)
      @row = row
    end

    def [](column)
      row[column]
    end

    def []=(column, value)
      row[column] = !!value
    end

    def to_s
      row.map { |tile| tile ? " " : "\u2588" }.join("")
    end

    def to_a
      row
    end

    def length
      row.length
    end
  end
end
