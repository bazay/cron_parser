shared_examples_for 'valid expression part' do |part_name, part_value, expected_output|
  let(:expression) { expression_string % expression_values.merge("#{part_name}": part_value) }

  it { is_expected.to eq expected_output }
end

shared_examples_for 'invalid expression part' do |part_name, part_value|
  let(:expression) { expression_string % expression_values.merge("#{part_name}": part_value) }

  it { expect { subject }.to raise_error ArgumentError }
end
