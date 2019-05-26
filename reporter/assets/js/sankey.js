/*!
* d3.chart.sankey - v0.4.0
* License: MIT
* Date: 2017-00-16
*/
! function(t, e) {
  if ("object" == typeof exports && "object" == typeof module) module.exports = e(require("d3"), require("d3.chart"));
  else if ("function" == typeof define && define.amd) define(["d3", "d3.chart"], e);
  else {
    var n = "object" == typeof exports ? e(require("d3"), require("d3.chart")) : e(t.d3, t.d3.chart);
    for (var r in n)("object" == typeof exports ? exports : t)[r] = n[r]
  }
}(this, function(t, e) {
  return function(t) {
    function e(r) {
      if (n[r]) return n[r].exports;
      var s = n[r] = {
        exports: {},
        id: r,
        loaded: !1
      };
      return t[r].call(s.exports, s, s.exports, e), s.loaded = !0, s.exports
    }
    var n = {};
    return e.m = t, e.c = n, e.p = "", e(0)
  }([function(t, e, n) {
    "use strict";
    var r = n(1);
    r.Sankey = r, r.Base = n(4), r.Selection = n(6), r.Path = n(7), t.exports = r
  }, function(t, e, n) {
    "use strict";
    var r = n(2),
    s = n(3),
    i = n(4);
    t.exports = i.extend("Sankey", {
      initialize: function() {
        function t(t) {
          var e = i.features.alignLabel;
          return "function" == typeof e && (e = e(t)), "auto" === e && (e = t.x < i.features.width / 2 ? "start" : "end"), e
        }

        function e(t) {
          return "function" == typeof i.features.colorNodes ? i.features.colorNodes(i.features.name(t), t) : i.features.colorNodes
        }

        function n(t) {
          return "function" == typeof i.features.colorLinks ? i.features.colorLinks(t) : i.features.colorLinks
        }
        var i = this;
        i.d3.sankey = s(), i.d3.path = d3.svg.diagonal()
        .source(function(d) {
          return {"x":d.source.y + d.source.dy / 2,
          "y":d.source.x + i.d3.sankey.nodeWidth()/2};
        })
        .target(function(d) {
          return {"x":d.target.y + d.target.dy / 2,
          "y":d.target.x + i.d3.sankey.nodeWidth()/2};
        })
        .projection(function(d) { return [d.y, d.x]; }), i.d3.sankey.size([i.features.width, i.features.height]), i.features.spread = !1, i.features.iterations = 32, i.features.nodeWidth = i.d3.sankey.nodeWidth(), i.features.nodePadding = i.d3.sankey.nodePadding(), i.features.alignLabel = "auto", i.layers.links = i.layers.base.append("g").classed("links", !0), i.layers.nodes = i.layers.base.append("g").classed("nodes", !0), i.on("change:sizes", function() {
          i.d3.sankey.nodeWidth(i.features.nodeWidth), i.d3.sankey.nodePadding(i.features.nodePadding)
        }), i.layer("links", i.layers.links, {
          dataBind: function(t) {
            return this.selectAll(".link").data(t.links)
          },
          insert: function() {
            return this.append("path").classed("link", !0)
          },
          events: {
            enter: function() {
              this.on("mouseover", function(t) {
                i.trigger("link:mouseover", t)
              }), this.on("mouseout", function(t) {
                i.trigger("link:mouseout", t)
              }), this.on("click", function(t) {
                i.trigger("link:click", t)
              })
            },
            merge: function() {
              this.attr("d", i.d3.path).style("stroke", n).style("stroke-width", function (d) {
                return Math.max(1, Math.sqrt(d.dy));
              }).sort(function(t, e) {
                return e.dy - t.dy
              })
            },
            exit: function() {
              this.remove()
            }
          }
        }), i.layer("nodes", i.layers.nodes, {
          dataBind: function(t) {
            return this.selectAll(".node").data(t.nodes)
          },
          insert: function() {
            return this.append("g").classed("node", !0).attr("data-node-id", function(t) {
              return t.id
            })
          },
          events: {
            enter: function() {
              this.append("circle")
            },
            merge: function() {
              this.attr("transform", function(t) {
                return "translate(" + t.x + "," + t.y + ")"
              }), this.select("circle").attr("cx", 10/2)
              .attr("cy", function (d) {
                return d.dy/2;
              })
              .attr("r", function (d) {
                return 10;
              })
              .style("fill", e)
              .style("cursor", function(t) {
                if(t.image) {
                  return "pointer";
                } else {
                  return "default";
                }
              })
              .on("mouseover", function(t) {
                mouseover(t, i);
              }).on("mouseout", function(t) {
                mouseout(t, i);
              })
              .on("click", function(t) {
                click(t, i);
              })
            },
            exit: function() {
              this.remove()
            }
          }
        })
      },
      transform: function(t) {
        var e = this;
        return e.data = t, e.d3.sankey.nodes(t.nodes).links(t.links).layout(e.features.iterations), this.features.spread && (this._spreadNodes(t), e.d3.sankey.relayout()), t
      },
      iterations: function(t) {
        return arguments.length ? (this.features.iterations = t, this.data && this.draw(this.data), this) : this.features.iterations
      },
      nodeWidth: function(t) {
        return arguments.length ? (this.features.nodeWidth = t, this.trigger("change:sizes"), this.data && this.draw(this.data), this) : this.features.nodeWidth
      },
      nodePadding: function(t) {
        return arguments.length ? (this.features.nodePadding = t, this.trigger("change:sizes"), this.data && this.draw(this.data), this) : this.features.nodePadding
      },
      spread: function(t) {
        return arguments.length ? (this.features.spread = t, this.data && this.draw(this.data), this) : this.features.spread
      },
      alignLabel: function(t) {
        return arguments.length ? (this.features.alignLabel = t, this.data && this.draw(this.data), this) : this.features.alignLabel
      },
      _spreadNodes: function(t) {
        var e = this,
        n = r.nest().key(function(t) {
          return t.x
        }).entries(t.nodes).map(function(t) {
          return t.values
        });
        n.forEach(function(t) {
          var n, s, i = r.sum(t, function(t) {
            return t.dy
          }),
          o = (e.features.height - i) / t.length,
          a = 0;
          for (t.sort(function(t, e) {
            return t.y - e.y
          }), n = 0; n < t.length; ++n) s = t[n], s.y = a, a += s.dy + o
        })
      }
    })
  }, function(e, n) {
    e.exports = t
  }, function(t, e, n) {
    var r = n(2);
    r.sankey = function() {
      function t() {
        g.forEach(function(t) {
          t.sourceLinks = [], t.targetLinks = []
        }), y.forEach(function(t) {
          var e = t.source,
          n = t.target;
          "number" == typeof e && (e = t.source = g[t.source]), "number" == typeof n && (n = t.target = g[t.target]), e.sourceLinks.push(t), n.targetLinks.push(t)
        })
      }

      function e() {
        g.forEach(function(t) {
          t.value = Math.max(r.sum(t.sourceLinks, c), r.sum(t.targetLinks, c))
        })
      }

      function n() {
        for (var t, e = g, n = 0; e.length;) t = [], e.forEach(function(e) {
          e.x = n, e.dx = h, e.sourceLinks.forEach(function(e) {
            t.push(e.target)
          })
        }), e = t, ++n;
        s(n), i((l[0] - h) / (n - 1))
      }

      function s(t) {
        g.forEach(function(e) {
          e.sourceLinks.length || (e.x = t - 1)
        })
      }

      function i(t) {
        g.forEach(function(e) {
          e.x *= t
        })
      }

      function o(t) {
        function e() {
          var t = r.min(a, function(t) {
            return (l[1] - (t.length - 1) * d) / r.sum(t, c)
          });
          a.forEach(function(e) {
            e.forEach(function(e, n) {
              e.y = n, e.dy = e.value * t
            })
          }), y.forEach(function(e) {
            e.dy = e.value * t
          })
        }

        function n(t) {
          function e(t) {
            return u(t.source) * t.value
          }
          a.forEach(function(n, s) {
            n.forEach(function(n) {
              if (n.targetLinks.length) {
                var s = r.sum(n.targetLinks, e) / r.sum(n.targetLinks, c);
                n.y += (s - u(n)) * t
              }
            })
          })
        }

        function s(t) {
          function e(t) {
            return u(t.target) * t.value
          }
          a.slice().reverse().forEach(function(n) {
            n.forEach(function(n) {
              if (n.sourceLinks.length) {
                var s = r.sum(n.sourceLinks, e) / r.sum(n.sourceLinks, c);
                n.y += (s - u(n)) * t
              }
            })
          })
        }

        function i() {
          a.forEach(function(t) {
            var e, n, r, s = 0,
            i = t.length;
            for (t.sort(o), r = 0; r < i; ++r) e = t[r], n = s - e.y, n > 0 && (e.y += n), s = e.y + e.dy + d;
            if (n = s - d - l[1], n > 0)
            for (s = e.y -= n, r = i - 2; r >= 0; --r) e = t[r], n = e.y + e.dy + d - s, n > 0 && (e.y -= n), s = e.y
          })
        }

        function o(t, e) {
          return t.y - e.y
        }
        var a = r.nest().key(function(t) {
          return t.x
        }).sortKeys(r.ascending).entries(g).map(function(t) {
          return t.values
        });
        e(), i();
        for (var f = 1; t > 0; --t) s(f *= .99), i(), n(f), i()
      }

      function a() {
        function t(t, e) {
          return t.source.y - e.source.y
        }

        function e(t, e) {
          return t.target.y - e.target.y
        }
        g.forEach(function(n) {
          n.sourceLinks.sort(e), n.targetLinks.sort(t)
        }), g.forEach(function(t) {
          var e = 0,
          n = 0;
          t.sourceLinks.forEach(function(t) {
            t.sy = e, e += t.dy
          }), t.targetLinks.forEach(function(t) {
            t.ty = n, n += t.dy
          })
        })
      }

      function u(t) {
        return t.y + t.dy / 2
      }

      function c(t) {
        return t.value
      }
      var f = {},
      h = 24,
      d = 8,
      l = [1, 1],
      g = [],
      y = [];
      return f.nodeWidth = function(t) {
        return arguments.length ? (h = +t, f) : h
      }, f.nodePadding = function(t) {
        return arguments.length ? (d = +t, f) : d
      }, f.nodes = function(t) {
        return arguments.length ? (g = t, f) : g
      }, f.links = function(t) {
        return arguments.length ? (y = t, f) : y
      }, f.size = function(t) {
        return arguments.length ? (l = t, f) : l
      }, f.layout = function(r) {
        return t(), e(), n(), o(r), a(), f
      }, f.relayout = function() {
        return a(), f
      }, f.link = function() {
        function t(t) {
          var n = t.source.x + t.source.dx,
          s = t.target.x,
          i = r.interpolateNumber(n, s),
          o = i(e),
          a = i(1 - e),
          u = t.source.y + t.sy + t.dy / 2,
          c = t.target.y + t.ty + t.dy / 2;
          return "M" + n + "," + u + "C" + o + "," + u + " " + a + "," + c + " " + s + "," + c
        }
        var e = .5;
        return t.curvature = function(n) {
          return arguments.length ? (e = +n, t) : e
        }, t
      }, f
    }, t.exports = r.sankey
  }, function(t, e, n) {
    "use strict";
    var r = n(2),
    s = n(5);
    t.exports = s("Sankey.Base", {
      initialize: function() {
        var t = this;
        t.features = {}, t.d3 = {}, t.layers = {}, t.base.attr("width") || t.base.attr("width", t.base.node().parentNode.clientWidth), t.base.attr("height") || t.base.attr("height", t.base.node().parentNode.clientHeight), t.features.margins = {
          top: 20,
          right: 20,
          bottom: 20,
          left: 20
        }, t.features.width = t.base.attr("width") - t.features.margins.left - t.features.margins.right, t.features.height = t.base.attr("height") - t.features.margins.top - t.features.margins.bottom, t.features.name = function(t) {
          return t.name
        }, t.features.colorNodes = r.scale.category20c(), t.features.colorLinks = null, t.layers.base = t.base.append("g").attr("transform", "translate(" + t.features.margins.left + "," + t.features.margins.top + ")")
      },
      name: function(t) {
        return arguments.length ? (this.features.name = t, this.trigger("change:name"), this.root && this.draw(this.root), this) : this.features.name
      },
      colorNodes: function(t) {
        return arguments.length ? (this.features.colorNodes = t, this.trigger("change:color"), this.root && this.draw(this.root), this) : this.features.colorNodes
      },
      colorLinks: function(t) {
        return arguments.length ? (this.features.colorLinks = t, this.trigger("change:color"), this.data && this.draw(this.data), this) : this.features.colorLinks
      }
    })
  }, function(t, n) {
    t.exports = e
  }, function(t, e, n) {
    "use strict";
    var r = n(1);
    t.exports = r.extend("Sankey.Selection", {
      initialize: function() {
        function t() {
          return n.features.selection && n.features.selection.length ? this.style("opacity", function(t) {
            return n.features.selection.indexOf(t) >= 0 ? 1 : n.features.unselectedOpacity
          }) : this.style("opacity", 1)
        }

        function e() {
          var e = n.layers.base.selectAll(".node, .link").transition();
          n.features.selection && n.features.selection.length || (e = e.delay(100)), t.apply(e.duration(50))
        }
        var n = this;
        n.features.selection = null, n.features.unselectedOpacity = .2, n.on("link:mouseover", n.selection), n.on("link:mouseout", function() {
          n.selection(null)
        }), n.on("node:mouseover", n.selection), n.on("node:mouseout", function() {
          n.selection(null)
        }), n.on("change:selection", e), this.layer("links").on("enter", t), this.layer("nodes").on("enter", t)
      },
      selection: function(t) {
        return arguments.length ? (this.features.selection = !t || t instanceof Array ? t : [t], this.trigger("change:selection"), this) : this.features.selection
      },
      unselectedOpacity: function(t) {
        return arguments.length ? (this.features.unselectedOpacity = t, this.trigger("change:selection"), this) : this.features.unselectedOpacity
      }
    })
  }, function(t, e, n) {
    "use strict";

    function r(t, e) {
      return t.source && t.target ? s(t, e) : i(t, e)
    }

    function s(t, e) {
      var n = [t];
      return e = e || "both", "source" != e && "both" != e || (n = n.concat(i(t.source, "source"))), "target" != e && "both" != e || (n = n.concat(i(t.target, "target"))), n
    }

    function i(t, e) {
      var n = [t];
      return e = e || "both", ("source" == e && t.sourceLinks.length < 2 || "both" == e) && t.targetLinks.forEach(function(t) {
        n = n.concat(s(t, e))
      }), ("target" == e && t.targetLinks.length < 2 || "both" == e) && t.sourceLinks.forEach(function(t) {
        n = n.concat(s(t, e))
      }), n
    }
    var o = n(6);
    t.exports = o.extend("Sankey.Path", {
      selection: function(t) {
        var e = this;
        return arguments.length ? (e.features.selection = !t || t instanceof Array ? t : [t], e.features.selection && e.features.selection.forEach(function(t) {
          r(t).forEach(function(t) {
            e.features.selection.push(t)
          })
        }), e.trigger("change:selection"), e) : e.features.selection
      }
    })
  }])
});

function mouseover(d, contexter) {
  margins = contexter.features.margins;
  height = contexter.features.height;
  width = contexter.features.width;

  text = contexter.base.append("text")
  .text(d.name)
  .attr("transform", null)
  .style("position", "relative")
  .style("font-weight", 800)
  .style("font-size", "15px")
  .style("text-align", "center")
  .attr("id", this.id)
  .attr("class", "scene-image");

  boundingRect = text.node().getBoundingClientRect();
  computedWidth = boundingRect.width;
  computedHeight = boundingRect.height;

  let xPosition = d.x + margins.left + d.dx + 10;
  let yPosition = d.y + d.dy/2;
  let endXPosition = xPosition + computedWidth;

  if(endXPosition > width) {
    xPosition -= (endXPosition-width)
  }

  text.attr("x", xPosition)
  .attr("y", yPosition)
  if(d.image) {
    var im = new Image();
    im.name = "Scene panel";
    im.id = "scene" + d.id;
    im.src = "data:image/png;base64," + d.image
    im.onload = function(e) {
      var h = 100;
      var ixPosition = d.x + margins.left + d.dx + 10; // 10 of separation from node
      var iyPosition = d.y + d.dy/2 + 10; // 10 of separation from label

      image = contexter.base.append("image")
      .data([this])
      .attr("x", ixPosition)
      .attr("y", iyPosition)
      .attr("height", 100)
      .attr("width", 50)
      .style("width", "auto")
      .attr("xlink:href", this.src)
      .attr("transform", null)
      .attr("id", this.id)
      .attr("class", "scene-image")

      imageBoundingRect = image.node().getBoundingClientRect();
      computedImageWidth = imageBoundingRect.width;
      computedImageHeight = imageBoundingRect.height;
      let endImageXPosition = ixPosition + computedImageWidth;
      let endImageYPosition = iyPosition + computedImageHeight;

      if(endImageXPosition > width) {
        ixPosition -= (endImageXPosition-width)
      }

      if(endImageYPosition > height + margins.bottom) {
        iyPosition -= (endImageYPosition-(height+margins.bottom))
      }

      image.attr("x", ixPosition)
      .attr("y", iyPosition);

      text.attr("y", iyPosition - 10);

      contexter.base.append('rect')
      .attr('class', 'scene-image')
      .attr('width', computedImageWidth)
      .attr('height', computedImageHeight)
      .attr('fill', 'transparent')
      .attr('stroke', 'black')
      .style('opacity', 0.25)
      .attr("x", ixPosition)
      .attr("y", iyPosition);
    }
  }
}

function mouseout(d, svg) {
  d3.selectAll("[class=\"scene-image\"]").remove();
}

function click(d, svg) {
  if(d.image) {
    var im = new Image();
    im.src = "data:image/png;base64," + d.image
    var w = window.open("",'_blank');
    w.document.write(im.outerHTML);
    w.document.close();
  }
}

function label(node) {
  return node.name.replace(/\s*\(.*?\)$/, '');
}

function getHeight(length, ratio) {
  var height = ((length)/(Math.sqrt((Math.pow(ratio, 2)+1))));
  return Math.round(height);
}

function getWidth(length, ratio) {
  var width = ((length)/(Math.sqrt((1)/(Math.pow(ratio, 2)+1))));
  return Math.round(width);
}
