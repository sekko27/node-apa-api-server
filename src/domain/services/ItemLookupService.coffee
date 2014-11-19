Helper = require('wire-context-helper').Helper()
Method = require Helper.util 'Method'

class ItemLookupService
  cache: null
  client: null
  baseParams: null

  itemLookup: (itemId) ->
    Method.promise (defer) =>
      @cache.exists(itemId).then(
        (found) =>
          defer.resolve if found then @cache.get(itemId) else @fetch(itemId)
        (err) -> defer.reject(err)
    )

  fetch: (itemId) ->
    params = _.merge {}, @baseParams, ItemId: itemId
    @cache.set itemId, @client.itemLookup(params)


module.exports = ItemLookupService
