require 'pry'
require 'cron_parser/argument_parser'
require 'cron_parser/expression_parser'
require 'cron_parser/table_printer'

module CronParser
  class Main
    attr_reader :arguments

    def initialize
      @arguments = ARGV
    end

    def execute
      print_table!
    end

    private

    def parsed_arguments
      ::CronParser::ArgumentParser.parse(arguments)
    end

    def parsed_expression
      ::CronParser::ExpressionParser.new(parsed_arguments.dig(:expression)).parse
    end

    def print_table!
      ::CronParser::TablePrinter.new(parsed_expression).print
    end
  end
end
