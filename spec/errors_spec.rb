require 'spec_helper'
describe 'ERRORS' do
  describe 'RequiredFieldNotPresent' do
    class RequiredField < Dystruct
      required :required
    end
    it do
      expected_message = '[Dystruct ERROR]: `RequiredField` expect to be initialized with `required` as an attribute.'
      expect { RequiredField.new(name: 'hello') }
        .to raise_error(Dystruct::RequiredFieldNotPresent, expected_message)
    end
    it { expect { RequiredField.new(required: 'hello') }.not_to raise_error}
  end
  describe '::ensure_presence' do
    class EnsurePresence < Dystruct
      ensure_presence :foo
    end
    context 'not nil' do
      subject { EnsurePresence.new(foo: :hello, bla: :bla) }
      it { expect(subject.foo).to eq :hello }
      it { expect{ subject.foo }.not_to raise_error }
    end
    context 'nil' do
      subject { EnsurePresence.new(foo: nil, some: :thing) }
      it do
        expected_message = '[Dystruct ERROR]: `EnsurePresence` expects to receive an attribute named `foo` not beeing `nil`'
        expect{ subject.foo }.to raise_error Dystruct::PresenceRequired, expected_message
      end
    end
  end

  describe 'WrongArgument' do
    it do
      # message = '[Dystruct ERROR]: `Dystruct` expects to receive an `Hash` or and object having `Hash` as ancestor.'
      expect{ Dystruct.new(nil) }.to raise_error Dystruct::WrongArgument#, message
    end
  end
end
