require 'pry'
require 'cron_parser/argument_parser'

module CronParser
  class Main
    attr_reader :arguments

    def initialize
      @arguments = ARGV
    end

    def execute
      return unless options && options[:expression]
    end

    private

    def options
      @options ||= ::CronParser::ArgumentParser.parse!(arguments)
    end
  end
end
