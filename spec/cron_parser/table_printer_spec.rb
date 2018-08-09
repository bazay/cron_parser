RSpec.describe CronParser::TablePrinter do
  let(:printer) { described_class.new parsed_expression }
  let(:parsed_expression) do
    {
      minute: Array(0..5),
      hour: Array(0..12),
      day_of_month: Array(1..15),
      month: Array(1..11),
      day_of_week: Array(1..5),
      command: ['/user/bin/find']
    }
  end

  describe '#print' do
    subject { -> { printer.print } }

    let(:expected_table_output) do
"+--------------+-------------------------------------+
| minute       | 0 1 2 3 4 5                         |
| hour         | 0 1 2 3 4 5 6 7 8 9 10 11 12        |
| day of month | 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 |
| month        | 1 2 3 4 5 6 7 8 9 10 11             |
| day of week  | 1 2 3 4 5                           |
| command      | /user/bin/find                      |
+--------------+-------------------------------------+
"
    end

    it { is_expected.to output(expected_table_output).to_stdout }
  end
end
