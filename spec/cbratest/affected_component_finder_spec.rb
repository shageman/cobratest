require 'spec_helper'

describe Cbratest::AffectedComponentFinder do
  describe '#find' do
    it 'includes a component if one of its files has been changed' do
      expect(Cbratest::AffectedComponentFinder.new.find(
                 [{name: "name", options: {path: '/some/path'}}],
                 ['/some/path/under/the/other']
             )).to eq (
                          {{:name => "name", :options => {:path => "/some/path"}} => true}
                      )
    end

    it 'does not include a component if none of its files has been changed' do
      expect(Cbratest::AffectedComponentFinder.new.find(
                 [{name: "name", options: {path: '/some/path'}}],
                 ['/some/other/path']
             )).to eq (
                          {{:name => "name", :options => {:path => "/some/path"}} => false}
                      )

    end
  end
end
