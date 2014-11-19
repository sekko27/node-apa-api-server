Helper = require('wire-context-helper').Helper()
Method = require Helper.util 'Method'

_ = require 'lodash'

module.exports = (adapter, storageKey = 'itemid') ->
  query = (key) ->
    _.zipObject [storageKey], key

  class CacheService
    get: (key) ->
      Method.promise (defer) ->
        adapter.findOne query(key), (err, file) ->
          return defer.reject(err) if err
          return defer.reject("Cache item not found: #{key}") if not file
          defer.resolve(adapter.createReadStream(file))

    exist: (key) ->
      Method.promise (defer) ->
        adapter.exists query(key), (err, found) ->
          return defer.reject(err) if err
          return defer.resolve(found)

    set: (key, stream) ->
      Method.promise (defer) ->
        ws = adapter.createWriteStream query(key)
        ws.on 'error', (err) -> defer.reject(err)
        ws.on 'close', (stored) -> defer.resolve(stored)
        stream.pipe ws

    remove: (key) ->
      Method.promise (defer) ->
        adapter.remove query(key), (err) ->
          return defer.reject(err) if err
          defer.resolve(null)


        