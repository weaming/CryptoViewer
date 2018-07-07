import 'dart:async';

var _cache = Map<String, dynamic>();

Future<dynamic> httpGetCache(String key, func, {int timeout=30, bool withState=false}) async {
  var now = DateTime.now().millisecondsSinceEpoch / 1000;
  var valid = _cache.containsKey(key) && (now - _cache[key]['ts']) < timeout;
  if (!valid) {
    var res = await func();
    _cache[key] = {
      "rv": res,
      "ts": now,
    };
  }

  if (withState) {
    return [_cache[key]['rv'], valid];
  }
  return _cache[key]['rv'];
}