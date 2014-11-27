require 'rspec'
require_relative '../../lib/codgen'

describe 'codgen' do
  config = {
    'templates' => [{'source' => 'data', 'in' => 'Input/hello_world.txt.mustache', 'out' => 'Output/hello_world.txt' }],
    'data' => { 'data' => [{'name' => 'World'}], 'foo' => 'blah' }
  }
  it 'should have one result' do
    expect(Codgen.run(config).length).to eq 1
  end
end