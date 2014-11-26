require 'rspec'
require_relative '../../lib/codgen/flattener'

describe 'Flattener' do
  data_root = {
    'root_prop1' => 'root_prop1_val',
    'prop2' => 'root_prop2_val',
    'object1' => {
      'prop3' => 'prop3_val',
      'object2' => {
        'array'  =>[
          {
              'prop1' => 'prop1_val',
              'prop2' => 'prop2_val'
          }
        ]
      }
    }
  }

  data_root2 = { 'data' => [{'name' => 'World'}], 'foo' => 'blah'}

  it 'should have prop1 = prop1_val when it flattens to object1.object2[0] given @data_root' do
    expect(Codgen::Flattener.merge(data_root, ['object1', 'object2', 'array'])[0]['prop1']).to eq('prop1_val')
  end

  it 'should have prop2 = prop2_val when it flattens to object1.object2[0] given @data_root' do
    expect(Codgen::Flattener.merge(data_root, ['object1', 'object2', 'array'])[0]['prop2']).to eq('prop2_val')
  end

  it 'should have root_prop1 = root_prop1_val when it flattens to object1.object2[0] @given data_root' do
    expect(Codgen::Flattener.merge(data_root, ['object1', 'object2', 'array'])[0]['root_prop1']).to eq('root_prop1_val')
  end

  # When data_root2
  it 'should have data as an array' do
    expect(Codgen::Flattener.merge(data_root2, ['data']).is_a?(Array)).to eq(true)
  end

  it 'should have a count of 1' do
    expect(Codgen::Flattener.merge(data_root2, ['data']).length).to eq(1)
  end

  it 'should get the main data properly' do
    expect(Codgen::Flattener.merge(data_root2, ['data'])[0]['name']).to eq('World')
  end

  it 'should get the parent data properly' do
    expect(Codgen::Flattener.merge(data_root2, ['data'])[0]['foo']).to eq('blah')
  end
end