module Refinements
  module ArrayDuplicatesHash
    refine Array do
      def dup_hash
        Hash.new(0).tap do |hash|
          each { |value| hash.store(value, hash[value] + 1) }
        end
      end
    end
  end
end
