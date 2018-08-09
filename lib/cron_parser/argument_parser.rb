require 'cron_parser/version'
require 'optparse'

module CronParser
  module ArgumentParser
    class << self
      def parse(arguments)
        options = {}
        OptionParser.new(nil, 32, ' ' * 2) do |opts|
          opts.banner = 'Usage:'
          opts.separator '  cron_parser [options]'
          opts.separator ''

          opts.separator 'Options:'

          opts.on(*expression_options) do |expression|
            options[:expression] = expression
          end

          opts.on_tail('-h', '--help', '# Show this help message and quit') do
            puts opts
          end

          opts.on_tail('-v', '--version', '# Show program version number and quit') do
            puts ::CronParser::VERSION
          end
        end.parse!(arguments)
        options
      rescue OptionParser::InvalidOption, OptionParser::MissingArgument => exception
        puts exception&.message
      end

      private

      def expression_options
        [
          '--expression EXPRESSION',
          '-e EXPRESSION',
          String,
          '# Provide the cron expression in string format: "m h D M d C"',
          '#   m = minute e.g. 0-59',
          '#   h = hour e.g. 0-23',
          '#   D = day of month e.g. 1-31',
          '#   M = month e.g. 0-11',
          '#   d = day of week e.g. 1-7',
          '#   C = command e.g. /usr/bin/find'
        ]
      end
    end
  end
end
