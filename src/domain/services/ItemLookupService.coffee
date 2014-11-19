class ItemLookupService
  client: null
  baseParams: null

  itemLookup: (itemId) ->
    params = _.merge {}, @baseParams, ItemId: itemId
    @client.itemLookup(params)

  
module.exports = ItemLookupService
