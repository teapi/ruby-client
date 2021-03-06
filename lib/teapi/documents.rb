module Teapi
  # Manages documents
  class Documents
    # creates a new document belonging to the given type
    # @param type [String] the document's type
    # @param doc [Hash] document to create
    # @param optional meta [Hash] meta data associated with the document
    def self.create(type, doc, meta = nil)
      d = {type: type, doc: doc}
      d[:meta] = meta unless meta.nil?
      Teapi.post(:documents, Oj.dump(d, mode: :compat, time_format: :ruby))
    end

    # updates the document belonging to the given type
    # @param type [String] the document's type
    # @param doc [Hash] the document to update
    # @param optional meta [Hash] meta data associated with the document
    def self.update(type, doc, meta = nil)
      d = {type: type, doc: doc}
      d[:meta] = meta unless meta.nil?
      Teapi.put(:documents, Oj.dump(d, mode: :compat, time_format: :ruby))
    end

    # deletes the document, by its id, belonging to the given type
    # @param type [String] the document's type
    # @param doc [Hash] the document to update
    def self.delete(type, id)
      Teapi.delete(:documents, Oj.dump({type: type, id: id}, mode: :compat, time_format: :ruby))
    end

    # bulk updates a type
    # @param type [String] the document's type
    # @param created_or_updated [Array[Hash]] an array of documents to be created or updated
    # @param deleted [Array[Hash]] an array of document [{id: 343}, {id: 9920},...]
    def self.bulk(type, created_or_updated, deleted)
      return if (created_or_updated.nil? || created_or_updated.length == 0) && (deleted.nil? || deleted.length == 0)
      Teapi.post(:documents, Oj.dump({type: type, deletes: deleted, upserts: created_or_updated}, mode: :compat, time_format: :ruby))
    end
  end
end
