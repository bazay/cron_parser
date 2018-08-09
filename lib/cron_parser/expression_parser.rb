require 'pry'
require 'refinements/array_duplicates_hash'

module CronParser
  class ExpressionParser
    attr_reader :expression

    using ::Refinements::ArrayDuplicatesHash

    EXPRESSION_PART_NAMES = %i[minute hour day_of_month month day_of_week command].freeze
    SPECIAL_CHARACTERS = %w[, - * /].freeze
    VALID_TIME_CHARACTERS = (%w[0 1 2 3 4 5 6 7 8 9] + SPECIAL_CHARACTERS).freeze
    COMBINABLE_SPECIAL_CHARACTERS = %w[* /].freeze

    def initialize(expression)
      @expression = expression.to_s
      @parsed_expression = {}
    end

    def parse
      return @parsed_expression unless @parsed_expression.empty?
      raise_error! unless correct_number_of_parts?

      @parsed_expression.tap do |parsed_expression|
        expression_parts.each_with_index do |expression_part, index|
          part_name, part_output = parse_expression_part(EXPRESSION_PART_NAMES[index], expression_part)
          parsed_expression[part_name] = part_output
        end
      end

    rescue ArgumentError => exception
      puts exception&.message
    end

    private

    def parse_expression_part(part_name, part_value)
      [part_name, parse_part_output(part_name, part_value)]
    end

    def parse_part_output(part_name, part_value)
      case part_name
      when :minute, :hour, :day_of_month, :month, :day_of_week
        parse_time_part(part_name, part_value)
      when :command
        Array part_value
      end
    end

    def parse_time_part(part_name, part_value)
      raise_error! if time_contains_invalid_characters?(part_value)
      if special_characters(part_value).any?
        parse_time_with_special_characters(part_name, part_value)
      else
        time_within_range?(part_name, part_value) ? Array(part_value) : raise_error!
      end
    end

    def parse_time_with_special_characters(part_name, part_value)
      unless special_characters(part_value).one?
        raise_error! unless multiple_special_characters_valid?(part_value)
        start_value = time_part_ranges[part_name].first
        part_value = part_value.gsub('*', start_value.to_s)
      end
      parse_specific_special_character(special_characters(part_value).first, part_name, part_value)
    end

    def parse_specific_special_character(special_character, part_name, part_value)
      split_values = part_value.split(special_character).map(&:to_i)
      case special_character
      when ','
        split_values
      when '-'
        Array (split_values.first..split_values.last)
      when '*'
        Array time_part_ranges[part_name]
      when '/'
        start_value, increment = split_values
        Array (start_value..time_part_ranges[part_name].last).step(increment)
      end
    end

    def part_value_with_special_valid?(special_character, part_name, split_values)
      case special_character
      when ','
        split_values.count == split_values.uniq.count &&
          split_values.select { |value| time_part_ranges[part_name].include?(value.to_i) }.count == 2
      when '-', '/'
        split_values.count == 2 &&
          split_values.first < split_values.last &&
          split_values.select { |value| time_part_ranges[part_name].include?(value.to_i) }.count == 2
      else
        true
      end
    end

    def special_characters(part_value)
      part_value.split('').select { |character| SPECIAL_CHARACTERS.include? character }
    end

    def special_characters_uniqueness_valid?(part_value)
      unique_characters = special_characters(part_value).dup_hash.keys

      # special cases
      # 1. multiple commas
      # 2. */15
      (unique_characters.one? && unique_characters.first == ',') ||
        (unique_characters.count == 2 && ((special_characters(part_value) - COMBINABLE_SPECIAL_CHARACTERS).none?))
    end

    def multiple_special_characters_valid?(part_value)
      special_characters_uniqueness_valid?(part_value)
    end

    def time_contains_invalid_characters?(part_value)
      (part_value.split('') - VALID_TIME_CHARACTERS).any?
    end

    def time_within_range?(part_name, part_value)
      time_part_ranges[part_name].include?(part_value.to_i)
    end

    def expression_parts
      @expression_parts ||= expression.split(' ')
    end

    def time_part_ranges
      {
        minute: 0..59,
        hour: 0..23,
        day_of_month: 1..31,
        month: 1..12,
        day_of_week: 1..7
      }
    end

    def correct_number_of_parts?
      expression_parts.count == 6
    end

    def raise_error!
      raise ArgumentError, 'Please ensure your expression is valid!'
    end
  end
end
