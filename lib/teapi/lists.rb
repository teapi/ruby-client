module Teapi
  # Manages lists
  class Lists
    # inserts the document ids into the start of the list
    # @param type [String] the list's type
    # @param list [String] the list to insert into
    # @param ids [array] the ids, or single id, to insert
    # @param optional truncate [bool] whether to truncate the existing list (replacing all the old ids with the new one)
    def self.insert(type, list, ids, truncate = false)
      ids = [ids] unless ids.is_a?(Array)
      d = {type: type, list: list, truncate: truncate, ids: ids}
      Teapi.post(:lists, Oj.dump(d, mode: :compat))
    end

    # deletes the document ids from the list
    # @param type [String] the list's type
    # @param list [String] the list to insert into
    # @param optional ids [array] the ids, or single id, to insert (nil to delete all)
    def self.delete(type, list, ids = nil)
      ids = [ids] unless ids.is_a?(Array) || ids.nil?
      d = {type: type, list: list, ids: ids}
      Teapi.delete(:lists, Oj.dump(d, mode: :compat))
    end
  end
end
