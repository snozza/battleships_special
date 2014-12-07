var ChuckNorris, http;

http = require('http');

module.exports = ChuckNorris = (function() {
  function ChuckNorris(fname, lname) {
    this.fname = fname !== null ? fname : 'Chuck';
    this.lname = lname !== null ? lname : 'Norris';
  }

  ChuckNorris.prototype.id = function(id, cb) {
    return this._joke('jokes/' + id, cb);
  };

  ChuckNorris.prototype.random = function(c, cb) {
    if (!cb) {
      return this._joke('jokes/random', c);
    } else {
      return this._jokes('jokes/random/' + c, cb);
    }
  };

  ChuckNorris.prototype.count = function(cb) {
    return this._value('jokes/count', cb);
  };

  ChuckNorris.prototype.categories = function(cb) {
    return this._value('categories', cb);
  };

  ChuckNorris.prototype._joke = function(f, cb) {
    return this._value(f, function(err, data) {
      if (err) {
        return cb(err);
      } else {
        return cb(null, data.joke.replace(/&quot;/g, '"'));
      }
    });
  };

  ChuckNorris.prototype._jokes = function(f, cb) {
    return this._value(f, function(err, data) {
      if (err) {
        return cb(err);
      } else {
        return cb(null, data.map(function(val) {
          return val.joke.replace(/&quot;/g, '"');
        }));
      }
    });
  };

  ChuckNorris.prototype._value = function(f, cb) {
    return this._req(f, function(err, data) {
      if (err) {
        return cb(err);
      } else {
        return cb(null, data.value);
      }
    });
  };

  ChuckNorris.prototype._req = function(f, cb) {
    var opts;
    opts = {
      path: '/' + f + '?firstName=' + this.fname + '&lastName=' + this.lname,
      host: 'api.icndb.com',
      port: 80
    };
    return http.get(opts, function(res) {
      var data;
      data = '';
      res.on('data', (function(_this) {
        return function(chunk) {
          return data += chunk;
        };
      })(this));
      return res.on('end', (function(_this) {
        return function() {
          var err;
          try {
            return cb(null, JSON.parse(data));
          } catch (_error) {
            err = _error;
            return cb(new Error('Response could not be parsed, api.icndb.com may be down.'));
          }
        };
      })(this));
    });
  };

  return ChuckNorris;

})();

chuck = new ChuckNorris()
chuck.random()
