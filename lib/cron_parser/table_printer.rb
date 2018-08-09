require 'terminal-table'

module CronParser
  class TablePrinter
    def initialize(parsed_expression)
      @parsed_expression = parsed_expression
      @rows = []
    end

    def print
      return unless @parsed_expression
      raise_error! if @parsed_expression.empty?
      build_rows
      puts table
    rescue ArgumentError => exception
      puts exception&.message
    end

    private

    def raise_error!
      raise ArgumentError, 'The table could not be printed - kick the developer'
    end

    def build_rows
      @parsed_expression.each_pair do |key, value|
        @rows << [key.to_s.gsub('_', ' '), value.join(' ')]
      end
    end

    def table
      Terminal::Table.new rows: @rows
    end
  end
end
