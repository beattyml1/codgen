require 'rspec'
require_relative '../../lib/codgen/template'

describe 'template' do
  config = {'source' => 'data', 'in' => 'Input/hello_world.txt.mustache', 'out' => 'Output/hello_world.txt' }
  data_root = { 'data' => [{'name' => 'World'}, 'foo' => 'blah']}
  template_text = 'Hello {{name}}'
  template = Codgen::Template.new(config, data_root)

  describe 'initialize' do
    it 'should get the input template file content properly' do
      expect(template.template).to eq('Hello {{name}}')
    end

    it 'should have data that is a flattened form of data_root.data' do
      expect(template.data).to eq(Codgen::Flattener.merge(data_root, ['data']))
    end
  end
  describe 'fill_template' do
    it 'should return a hash' do
      expect(template.fill_template.is_a?(Hash)).to eq(true)
    end
    it 'should return a output file with location "Output/hello_world.txt"' do
      expect(template.fill_template.keys[0]).to eq('Output/hello_world.txt')
    end
  end
end