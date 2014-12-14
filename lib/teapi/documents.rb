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
      Teapi.put(:documents, Oj.dump({type: type, doc: doc}, mode: :compat))
    end

    # deletes the document, by its id, belonging to the given type
    # @param type [String] the document's type
    # @param doc [Hash] the document to update
    def self.delete(type, id)
      Teapi.delete(:documents, Oj.dump({type: type, id: id}, mode: :compat))
    end
  end
end
