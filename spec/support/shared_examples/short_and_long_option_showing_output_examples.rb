shared_examples_for 'short and long option showing output' do |option, expected_output|
  context 'with short option' do
    let(:arguments) { %W[-#{option[0]}] }

    it { is_expected.to output(expected_output).to_stdout }
  end

  context 'with long option' do
    let(:arguments) { %W[--#{option}] }

    it { is_expected.to output(expected_output).to_stdout }
  end
end
