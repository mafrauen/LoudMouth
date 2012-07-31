// Generated by CoffeeScript 1.3.3
(function() {
  var adjustLimit, displayTweets, getLimit, graph, handleKeyPress, limitDown, limitUp, loadTweets, tweets,
    __hasProp = {}.hasOwnProperty;

  tweets = [];

  loadTweets = function(data) {
    tweets = data;
    return displayTweets();
  };

  getLimit = function() {
    return +$('#limit').val();
  };

  adjustLimit = function() {
    return displayTweets(getLimit());
  };

  limitUp = function() {
    var limit;
    limit = getLimit();
    if (limit > 19) {
      return;
    }
    $('#limit').val(limit + 1);
    return adjustLimit();
  };

  limitDown = function() {
    var limit;
    limit = getLimit();
    if (limit < 2) {
      return;
    }
    $('#limit').val(limit - 1);
    return adjustLimit();
  };

  displayTweets = function(limit) {
    var data, group, groups, lastTime, lastTweet, size, user;
    groups = _.groupBy(tweets, function(tweet) {
      return tweet.user.name;
    });
    data = [];
    limit = limit || 1;
    for (user in groups) {
      if (!__hasProp.call(groups, user)) continue;
      group = groups[user];
      size = group.length;
      if (size < limit) {
        continue;
      }
      data.push({
        packageName: user,
        className: user,
        value: size
      });
    }
    $('#graph').empty();
    graph('#graph', {
      children: data
    });
    lastTweet = tweets[tweets.length - 1];
    lastTime = new Date(lastTweet.created_at);
    $('#since').show();
    return $('#sinceTime').html(lastTime.toLocaleTimeString());
  };

  handleKeyPress = function(e) {
    var j, k;
    j = 106;
    k = 107;
    switch (e.keyCode) {
      case k:
        return limitUp();
      case j:
        return limitDown();
    }
  };

  jQuery(function() {
    var socket;
    socket = io.connect();
    socket.on('tweets', loadTweets);
    socket.emit('getTweets', {
      count: 200
    });
    $('#since').hide();
    $('#changeLimit').click(adjustLimit);
    return $('body').keypress(handleKeyPress);
  });

  graph = function(id, data) {
    var bubble, fill, format, node, r, vis;
    r = 720;
    format = d3.format(",d");
    fill = d3.scale.category20c();
    bubble = d3.layout.pack().sort(null).size([r, r]);
    vis = d3.select(id).append("svg").attr("width", r).attr("height", r).attr("class", "bubble");
    node = vis.selectAll("g.node").data(bubble.nodes(data).filter(function(d) {
      return !d.children;
    })).enter().append("g").attr("class", "node").attr("transform", function(d) {
      return "translate(" + d.x + "," + d.y + ")";
    });
    node.append("title").text(function(d) {
      return d.className + ": " + format(d.value);
    });
    node.append("circle").attr("r", function(d) {
      return d.r;
    }).style("fill", function(d) {
      return fill(d.packageName);
    });
    return node.append("text").attr("text-anchor", "middle").attr("dy", ".3em").text(function(d) {
      return d.className.substring(0, d.r / 3);
    });
  };

}).call(this);