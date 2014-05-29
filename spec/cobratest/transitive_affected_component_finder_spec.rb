require 'spec_helper'

describe Cbratest::TransitiveAffectedComponentFinder do
  describe '#find' do
    it 'marks components as affected that depend on affected components' do
      path = File.expand_path(File.join(__FILE__, "..", "..", "..", "spec", "examples", "letters"))

      expect(Cbratest::TransitiveAffectedComponentFinder.new.find(
                 {
                     {name: 'A', options: {path: File.join(path, 'A')}} => false,
                     {name: 'B', options: {path: File.join(path, 'B')}} => true,
                     {name: 'C', options: {path: File.join(path, 'C')}} => false
                 }
             )).to eq (
                          {
                              {name: 'A', options: {path: File.join(path, 'A')}} => true,
                              {name: 'B', options: {path: File.join(path, 'B')}} => true,
                              {name: 'C', options: {path: File.join(path, 'C')}} => false
                          }
                      )
    end

    it 'does not unmark components that once they are marked' do
      path = File.expand_path(File.join(__FILE__, "..", "..", "..", "spec", "examples", "letters"))

      expect(Cbratest::TransitiveAffectedComponentFinder.new.find(
                 {
                     {name: 'A', options: {path: File.join(path, 'A')}} => true,
                     {name: 'B', options: {path: File.join(path, 'B')}} => false,
                     {name: 'C', options: {path: File.join(path, 'C')}} => false
                 }
             )).to eq (
                          {
                              {name: 'A', options: {path: File.join(path, 'A')}} => true,
                              {name: 'B', options: {path: File.join(path, 'B')}} => false,
                              {name: 'C', options: {path: File.join(path, 'C')}} => false
                          }
                      )
    end
  end
end