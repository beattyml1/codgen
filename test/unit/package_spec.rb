require 'rspec'
require 'given_when_then'
require_relative '../../lib/codgen/package'

describe 'Package' do
  Given 'A unpacked package with a string input' do
    path = 'Input/package_test_dir'
    When 'the package object is initialized' do
      package = Codgen::Package.new(path)
      Then 'the path to the templates pointed at package path' do
        expect(package.unpacked_path).to eq 'Input/package_test_dir'
      end

      Then 'templates should be an array' do
        expect(package.templates.is_a?(Array)).to eq true
      end

      Then 'templates should have one element' do
        expect(package.templates.length).to eq 1
      end

      Then 'the first template should have an "in" value of "Input/package_test_dir/templates/package_hello_world.txt.mustache"' do
        expect(package.templates[0]['in']).to eq 'Input/package_test_dir/templates/package_hello_world.txt.mustache'
      end

      Then 'the first template should have an "out" value of "Output/package_hello_world.txt"' do
        expect(package.templates[0]['out']).to eq 'Output/package_hello_world.txt'
      end

      Then 'config should be a hash' do
        expect(package.config.is_a?(Hash)).to eq true
      end
    end
  end

  Given 'A compressed package with a string path input' do
    path = 'Input/package_test_zip.zip'
    When 'the package object is initialized' do
      package = Codgen::Package.new(path)
      Then 'the path to the templates pointed at the unpacked directory' do
        expect(package.unpacked_path).to eq 'package_test_zip'
      end

      Then 'templates should be an array' do
        expect(package.templates.is_a?(Array)).to eq true
      end

      Then 'templates should have one element' do
        expect(package.templates.length).to eq 1
      end

      Then 'the first template should have an "in" value of "package_test_zip/templates/package_zip_hello_world.txt.mustache"' do
        expect(package.templates[0]['in']).to eq 'package_test_zip/templates/package_zip_hello_world.txt.mustache'
      end

      Then 'the first template should have an "out" value of "Output/package_zip_hello_world.txt"' do
        expect(package.templates[0]['out']).to eq 'Output/package_zip_hello_world.txt'
      end

      Then 'config should be a hash' do
        expect(package.config.is_a?(Hash)).to eq true
      end
    end
  end

  Given 'A unpacked package with a json object with path property' do
    package_info = { 'path' => 'Input/package_test_dir' }
    When 'the package object is initialized' do
      package = Codgen::Package.new(package_info)
      Then 'the path to the templates pointed at package path' do
        expect(package.unpacked_path).to eq 'Input/package_test_dir'
      end

      Then 'templates should be an array' do
        expect(package.templates.is_a?(Array)).to eq true
      end

      Then 'templates should have one element' do
        expect(package.templates.length).to eq 1
      end

      Then 'the first template should have an "in" value of "Input/package_test_dir/templates/package_hello_world.txt.mustache"' do
        expect(package.templates[0]['in']).to eq 'Input/package_test_dir/templates/package_hello_world.txt.mustache'
      end

      Then 'the first template should have an "out" value of "Output/package_hello_world.txt"' do
        expect(package.templates[0]['out']).to eq 'Output/package_hello_world.txt'
      end

      Then 'config should be a hash' do
        expect(package.config.is_a?(Hash)).to eq true
      end
    end
  end
end