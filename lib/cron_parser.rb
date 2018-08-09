require 'pry'
require 'cron_parser/argument_parser'
require 'cron_parser/expression_parser'

module CronParser
  class Main
    attr_reader :arguments

    def initialize
      @arguments = ARGV
    end

    def execute
      puts expression_parser.parse
    end

    private

    def parsed_arguments
      ::CronParser::ArgumentParser.parse(arguments)
    end

    def expression_parser
      @expression_parser ||= ::CronParser::ExpressionParser.new(parsed_arguments.dig(:expression))
    end
  end
end
