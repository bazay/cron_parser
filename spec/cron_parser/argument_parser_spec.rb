RSpec.describe CronParser::ArgumentParser do
  subject(:parser) { described_class }

  describe '.parse' do
    subject { -> { parser.parse(arguments) } }

    let(:arguments) { [] }

    it 'arguments is empty' do
      is_expected.not_to output.to_stdout
    end

    it_behaves_like 'short and long option showing output', 'help', /Options:/
    it_behaves_like 'short and long option showing output', 'version', /#{::CronParser::VERSION}/

    context 'when arguments contains an invalid option' do
      let(:arguments) { %w[--eggspression] }
      let(:expected_output) { /#{'invalid option: ' + arguments[0]}/ }

      it { is_expected.to output(expected_output).to_stdout }
    end

    context 'when arguments contains expression option' do
      subject { parser.parse(arguments) }

      let(:expression_argument) { '*/15 0 1,15 * 1-5 /user/bin/find' }
      let(:arguments) { [expression_option, expression_argument] }
      let(:expected_hash) { { expression: expression_argument } }

      context 'with -e option' do
        let(:expression_option) { '-e' }

        it { is_expected.to eq expected_hash }
      end

      context 'with --expression option' do
        let(:expression_option) { '--expression' }

        it { is_expected.to eq expected_hash }
      end

      context 'with no expression argument' do
        subject { -> { parser.parse(arguments) } }

        it_behaves_like 'short and long option showing output', 'expression', /missing argument: /
      end
    end
  end
end
