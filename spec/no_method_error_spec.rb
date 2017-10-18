require 'spec_helper'
describe 'NoMethodError' do

  subject do
    class Hello < Dystruct
      no_method_error
    end
    Hello.new(foo: :foo, bar: :bar)
  end

  it { expect(subject.foo).to eq :foo }
  it { expect { subject.bla }.to raise_error NoMethodError }

  context 'default behavior' do
    subject { Dystruct.new(foo: :foo, bar: :bar) }
    it { expect(subject.foo).to eq :foo }
    it { expect { subject.bla }.to raise_error NoMethodError }
  end
end
