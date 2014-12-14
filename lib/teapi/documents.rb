module Teapi
  # Manages documents
  class Documents
    # creates a new document belonging to the given type
    # @param type [String] the document's type
    # @param doc [Hash] the json-serialized document
    def self.create(type, doc)
      Teapi.post(:documents, Oj.dump({type: type, doc: doc}, mode: :compat))
    end
  end
end
