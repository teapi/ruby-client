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

    # bulk updates a type
    # @param type [String] the document's type
    # @param created_or_updated [Array[Hash]] an array of documents to be created or updated
    # @param deleted [Array[Hash]] an array of document [{id: 343}, {id: 9920},...]
    def self.bulk(type, created_or_updated, deleted)
      return if (created_or_updated.nil? || created_or_updated.length == 0) && (deleted.nil? || deleted.length == 0)
      Teapi.post(:documents, Oj.dump({type: type, deletes: deleted, upserts: created_or_updated}, mode: :compat))
    end
  end
end
