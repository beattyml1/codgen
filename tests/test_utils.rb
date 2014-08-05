module TestUtils
  def self.recursive_compare(expectation_directory, output_directory)
    files_and_folders = Dir.glob(expectation_directory+'/**/*')
    error = false
    files_and_folders.each do |expected_file_path|
      if File.file?(expected_file_path)
        output_file_path = expected_file_path.sub(expectation_directory, output_directory)
        unless FileUtils.cmp(expected_file_path, output_file_path)
          puts "Error: '#{output_file_path}' does not match '#{expected_file_path}"
          error = true
        end
      end
    end
    return error
  end
end