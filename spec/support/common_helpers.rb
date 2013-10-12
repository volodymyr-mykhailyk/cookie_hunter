def change_model(model, method)
  change { model.reload.send(method) }
end

RSpec::Matchers.define :return_value do |expected|
  match do |actual|
    @actual_result = actual.respond_to?(:call) ? actual.call : actual
    expected == @actual_result
  end

  failure_message_for_should do |actual|
    "Expected to return '#{expected.inspect}' but returned '#{@actual_result.inspect}'."
  end
end
