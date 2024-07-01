# frozen_string_literal: true

def load_fixture(fixture_name, **values)
  file_path = "./spec/fixtures/#{fixture_name}.json.erb"
  b = binding
  values.each do |variable, value|
    b.local_variable_set(variable, value)
  end
  ERB.new(File.read(file_path)).result(b)
end
