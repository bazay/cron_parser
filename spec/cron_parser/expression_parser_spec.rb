RSpec.describe CronParser::ExpressionParser do
  subject(:parser) { described_class.new expression }

  let(:expression) { expression_string % expression_values }
  let(:expression_string) { "%{minute} %{hour} %{day_of_month} %{month} %{day_of_week} %{command}" }
  let(:expression_values) do
    {
      minute: '0',
      hour: '0',
      day_of_month: '1',
      month: '1',
      day_of_week: '1',
      command: command
    }
  end
  let(:command) { '/user/bin/find' }

  describe '#parse' do
    subject(:parsed_expression) { parser.parse }

    let(:expected_parsed_expression) do
      {
        minute: %w[0],
        hour: %w[0],
        day_of_month: %w[1],
        month: %w[1],
        day_of_week: %w[1],
        command: [command]
      }
    end

    it { is_expected.to eq expected_parsed_expression }

    describe 'special characters' do
      context 'when expression includes comma' do
        let(:expression_values) do
          {
            minute: '0,10,20,30',
            hour: '0,12',
            day_of_month: '1,15',
            month: '1,3,5,7,9,11',
            day_of_week: '1,3,5',
            command: command
          }
        end
        # I'm sorry for the below
        let(:expected_parsed_expression) do
          Hash[expression_values.each_pair.map { |key, value| key == :command ? [key, [value]] : [key, value.split(',').map(&:to_i)] }]
        end

        it { is_expected.to eq expected_parsed_expression }
      end

      context 'when expression includes dash' do
        let(:expression_values) do
          {
            minute: '0-5',
            hour: '0-12',
            day_of_month: '1-15',
            month: '1-11',
            day_of_week: '1-5',
            command: command
          }
        end
        let(:expected_parsed_expression) do
          {
            minute: Array(0..5),
            hour: Array(0..12),
            day_of_month: Array(1..15),
            month: Array(1..11),
            day_of_week: Array(1..5),
            command: [command]
          }
        end

        it { is_expected.to eq expected_parsed_expression }
      end

      context 'when expression includes asterisks' do
        let(:expression_values) do
          {
            minute: '*',
            hour: '*',
            day_of_month: '*',
            month: '*',
            day_of_week: '*',
            command: command
          }
        end
        let(:expected_parsed_expression) do
          {
            minute: Array(0..59),
            hour: Array(0..23),
            day_of_month: Array(1..31),
            month: Array(1..12),
            day_of_week: Array(1..7),
            command: [command]
          }
        end

        it { is_expected.to eq expected_parsed_expression }
      end

      context 'when expression includes forward slash' do
        let(:expression_values) do
          {
            minute: '*/15',
            hour: '5/10',
            day_of_month: '*/15',
            month: '*/6',
            day_of_week: '5/7',
            command: command
          }
        end
        let(:expected_parsed_expression) do
          {
            minute: [0, 15, 30, 45],
            hour: [5, 15],
            day_of_month: [1, 16, 31],
            month: [1, 7],
            day_of_week: [5],
            command: [command]
          }
        end

        it { is_expected.to eq expected_parsed_expression }
      end
    end
  end
end
