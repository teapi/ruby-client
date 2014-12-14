module Teapi
  # Manages documents
  class Documents
    # creates a new document belonging to the given type
    # @param type [String] the document's type
    # @param doc [Hash] document to create
    def self.create(type, doc)
      Teapi.post(:documents, Oj.dump({type: type, doc: doc}, mode: :compat))
    end

    # updates the document belonging to the given type
    # @param type [String] the document's type
    # @param doc [Hash] the document to update
    def self.update(type, doc)
      Teapi.post(:documents, Oj.dump({type: type, doc: doc}, mode: :compat))
    end
  end
end
