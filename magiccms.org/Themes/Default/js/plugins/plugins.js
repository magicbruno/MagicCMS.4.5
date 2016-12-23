///#source 1 1 /Themes/Default/js/plugins/spin/spin.js
/**
 * Copyright (c) 2011-2014 Felix Gnass
 * Licensed under the MIT license
 */
(function(root, factory) {

  /* CommonJS */
  if (typeof exports == 'object')  module.exports = factory()

  /* AMD module */
  else if (typeof define == 'function' && define.amd) define(factory)

  /* Browser global */
  else root.Spinner = factory()
}
(this, function() {
  "use strict";

  var prefixes = ['webkit', 'Moz', 'ms', 'O'] /* Vendor prefixes */
    , animations = {} /* Animation rules keyed by their name */
    , useCssAnimations /* Whether to use CSS animations or setTimeout */

  /**
   * Utility function to create elements. If no tag name is given,
   * a DIV is created. Optionally properties can be passed.
   */
  function createEl(tag, prop) {
    var el = document.createElement(tag || 'div')
      , n

    for(n in prop) el[n] = prop[n]
    return el
  }

  /**
   * Appends children and returns the parent.
   */
  function ins(parent /* child1, child2, ...*/) {
    for (var i=1, n=arguments.length; i<n; i++)
      parent.appendChild(arguments[i])

    return parent
  }

  /**
   * Insert a new stylesheet to hold the @keyframe or VML rules.
   */
  var sheet = (function() {
    var el = createEl('style', {type : 'text/css'})
    ins(document.getElementsByTagName('head')[0], el)
    return el.sheet || el.styleSheet
  }())

  /**
   * Creates an opacity keyframe animation rule and returns its name.
   * Since most mobile Webkits have timing issues with animation-delay,
   * we create separate rules for each line/segment.
   */
  function addAnimation(alpha, trail, i, lines) {
    var name = ['opacity', trail, ~~(alpha*100), i, lines].join('-')
      , start = 0.01 + i/lines * 100
      , z = Math.max(1 - (1-alpha) / trail * (100-start), alpha)
      , prefix = useCssAnimations.substring(0, useCssAnimations.indexOf('Animation')).toLowerCase()
      , pre = prefix && '-' + prefix + '-' || ''

    if (!animations[name]) {
      sheet.insertRule(
        '@' + pre + 'keyframes ' + name + '{' +
        '0%{opacity:' + z + '}' +
        start + '%{opacity:' + alpha + '}' +
        (start+0.01) + '%{opacity:1}' +
        (start+trail) % 100 + '%{opacity:' + alpha + '}' +
        '100%{opacity:' + z + '}' +
        '}', sheet.cssRules.length)

      animations[name] = 1
    }

    return name
  }

  /**
   * Tries various vendor prefixes and returns the first supported property.
   */
  function vendor(el, prop) {
    var s = el.style
      , pp
      , i

    prop = prop.charAt(0).toUpperCase() + prop.slice(1)
    for(i=0; i<prefixes.length; i++) {
      pp = prefixes[i]+prop
      if(s[pp] !== undefined) return pp
    }
    if(s[prop] !== undefined) return prop
  }

  /**
   * Sets multiple style properties at once.
   */
  function css(el, prop) {
    for (var n in prop)
      el.style[vendor(el, n)||n] = prop[n]

    return el
  }

  /**
   * Fills in default values.
   */
  function merge(obj) {
    for (var i=1; i < arguments.length; i++) {
      var def = arguments[i]
      for (var n in def)
        if (obj[n] === undefined) obj[n] = def[n]
    }
    return obj
  }

  /**
   * Returns the absolute page-offset of the given element.
   */
  function pos(el) {
    var o = { x:el.offsetLeft, y:el.offsetTop }
    while((el = el.offsetParent))
      o.x+=el.offsetLeft, o.y+=el.offsetTop

    return o
  }

  /**
   * Returns the line color from the given string or array.
   */
  function getColor(color, idx) {
    return typeof color == 'string' ? color : color[idx % color.length]
  }

  // Built-in defaults

  var defaults = {
    lines: 12,            // The number of lines to draw
    length: 7,            // The length of each line
    width: 5,             // The line thickness
    radius: 10,           // The radius of the inner circle
    rotate: 0,            // Rotation offset
    corners: 1,           // Roundness (0..1)
    color: '#000',        // #rgb or #rrggbb
    direction: 1,         // 1: clockwise, -1: counterclockwise
    speed: 1,             // Rounds per second
    trail: 100,           // Afterglow percentage
    opacity: 1/4,         // Opacity of the lines
    fps: 20,              // Frames per second when using setTimeout()
    zIndex: 2e9,          // Use a high z-index by default
    className: 'spinner', // CSS class to assign to the element
    top: '50%',           // center vertically
    left: '50%',          // center horizontally
    position: 'absolute'  // element position
  }

  /** The constructor */
  function Spinner(o) {
    this.opts = merge(o || {}, Spinner.defaults, defaults)
  }

  // Global defaults that override the built-ins:
  Spinner.defaults = {}

  merge(Spinner.prototype, {

    /**
     * Adds the spinner to the given target element. If this instance is already
     * spinning, it is automatically removed from its previous target b calling
     * stop() internally.
     */
    spin: function(target) {
      this.stop()

      var self = this
        , o = self.opts
        , el = self.el = css(createEl(0, {className: o.className}), {position: o.position, width: 0, zIndex: o.zIndex})
        , mid = o.radius+o.length+o.width

      css(el, {
        left: o.left,
        top: o.top
      })
        
      if (target) {
        target.insertBefore(el, target.firstChild||null)
      }

      el.setAttribute('role', 'progressbar')
      self.lines(el, self.opts)

      if (!useCssAnimations) {
        // No CSS animation support, use setTimeout() instead
        var i = 0
          , start = (o.lines - 1) * (1 - o.direction) / 2
          , alpha
          , fps = o.fps
          , f = fps/o.speed
          , ostep = (1-o.opacity) / (f*o.trail / 100)
          , astep = f/o.lines

        ;(function anim() {
          i++;
          for (var j = 0; j < o.lines; j++) {
            alpha = Math.max(1 - (i + (o.lines - j) * astep) % f * ostep, o.opacity)

            self.opacity(el, j * o.direction + start, alpha, o)
          }
          self.timeout = self.el && setTimeout(anim, ~~(1000/fps))
        })()
      }
      return self
    },

    /**
     * Stops and removes the Spinner.
     */
    stop: function() {
      var el = this.el
      if (el) {
        clearTimeout(this.timeout)
        if (el.parentNode) el.parentNode.removeChild(el)
        this.el = undefined
      }
      return this
    },

    /**
     * Internal method that draws the individual lines. Will be overwritten
     * in VML fallback mode below.
     */
    lines: function(el, o) {
      var i = 0
        , start = (o.lines - 1) * (1 - o.direction) / 2
        , seg

      function fill(color, shadow) {
        return css(createEl(), {
          position: 'absolute',
          width: (o.length+o.width) + 'px',
          height: o.width + 'px',
          background: color,
          boxShadow: shadow,
          transformOrigin: 'left',
          transform: 'rotate(' + ~~(360/o.lines*i+o.rotate) + 'deg) translate(' + o.radius+'px' +',0)',
          borderRadius: (o.corners * o.width>>1) + 'px'
        })
      }

      for (; i < o.lines; i++) {
        seg = css(createEl(), {
          position: 'absolute',
          top: 1+~(o.width/2) + 'px',
          transform: o.hwaccel ? 'translate3d(0,0,0)' : '',
          opacity: o.opacity,
          animation: useCssAnimations && addAnimation(o.opacity, o.trail, start + i * o.direction, o.lines) + ' ' + 1/o.speed + 's linear infinite'
        })

        if (o.shadow) ins(seg, css(fill('#000', '0 0 4px ' + '#000'), {top: 2+'px'}))
        ins(el, ins(seg, fill(getColor(o.color, i), '0 0 1px rgba(0,0,0,.1)')))
      }
      return el
    },

    /**
     * Internal method that adjusts the opacity of a single line.
     * Will be overwritten in VML fallback mode below.
     */
    opacity: function(el, i, val) {
      if (i < el.childNodes.length) el.childNodes[i].style.opacity = val
    }

  })


  function initVML() {

    /* Utility function to create a VML tag */
    function vml(tag, attr) {
      return createEl('<' + tag + ' xmlns="urn:schemas-microsoft.com:vml" class="spin-vml">', attr)
    }

    // No CSS transforms but VML support, add a CSS rule for VML elements:
    sheet.addRule('.spin-vml', 'behavior:url(#default#VML)')

    Spinner.prototype.lines = function(el, o) {
      var r = o.length+o.width
        , s = 2*r

      function grp() {
        return css(
          vml('group', {
            coordsize: s + ' ' + s,
            coordorigin: -r + ' ' + -r
          }),
          { width: s, height: s }
        )
      }

      var margin = -(o.width+o.length)*2 + 'px'
        , g = css(grp(), {position: 'absolute', top: margin, left: margin})
        , i

      function seg(i, dx, filter) {
        ins(g,
          ins(css(grp(), {rotation: 360 / o.lines * i + 'deg', left: ~~dx}),
            ins(css(vml('roundrect', {arcsize: o.corners}), {
                width: r,
                height: o.width,
                left: o.radius,
                top: -o.width>>1,
                filter: filter
              }),
              vml('fill', {color: getColor(o.color, i), opacity: o.opacity}),
              vml('stroke', {opacity: 0}) // transparent stroke to fix color bleeding upon opacity change
            )
          )
        )
      }

      if (o.shadow)
        for (i = 1; i <= o.lines; i++)
          seg(i, -2, 'progid:DXImageTransform.Microsoft.Blur(pixelradius=2,makeshadow=1,shadowopacity=.3)')

      for (i = 1; i <= o.lines; i++) seg(i)
      return ins(el, g)
    }

    Spinner.prototype.opacity = function(el, i, val, o) {
      var c = el.firstChild
      o = o.shadow && o.lines || 0
      if (c && i+o < c.childNodes.length) {
        c = c.childNodes[i+o]; c = c && c.firstChild; c = c && c.firstChild
        if (c) c.opacity = val
      }
    }
  }

  var probe = css(createEl('group'), {behavior: 'url(#default#VML)'})

  if (!vendor(probe, 'transform') && probe.adj) initVML()
  else useCssAnimations = vendor(probe, 'animation')

  return Spinner

}));

///#source 1 1 /Themes/Default/js/plugins/spin/jquery.spin.js
/**
 * Copyright (c) 2011-2014 Felix Gnass
 * Licensed under the MIT license
 */

/*

Basic Usage:
============

$('#el').spin(); // Creates a default Spinner using the text color of #el.
$('#el').spin({ ... }); // Creates a Spinner using the provided options.

$('#el').spin(false); // Stops and removes the spinner.

Using Presets:
==============

$('#el').spin('small'); // Creates a 'small' Spinner using the text color of #el.
$('#el').spin('large', '#fff'); // Creates a 'large' white Spinner.

Adding a custom preset:
=======================

$.fn.spin.presets.flower = {
  lines: 9,
  length: 10,
  width: 20,
  radius: 0
}

$('#el').spin('flower', 'red');

*/

(function(factory) {

  if (typeof exports == 'object') {
    // CommonJS
    factory(require('jquery'), require('spin'))
  }
  else if (typeof define == 'function' && define.amd) {
    // AMD, register as anonymous module
    define(['jquery', 'spin'], factory)
  }
  else {
    // Browser globals
    if (!window.Spinner) throw new Error('Spin.js not present')
    factory(window.jQuery, window.Spinner)
  }

}(function($, Spinner) {

  $.fn.spin = function(opts, color) {

    return this.each(function() {
      var $this = $(this),
        data = $this.data();

      if (data.spinner) {
        data.spinner.stop();
        delete data.spinner;
      }
      if (opts !== false) {
        opts = $.extend(
          { color: color || $this.css('color') },
          $.fn.spin.presets[opts] || opts
        )
        data.spinner = new Spinner(opts).spin(this)
      }
    })
  }

  $.fn.spin.presets = {
    tiny: { lines: 8, length: 2, width: 2, radius: 3 },
    small: { lines: 8, length: 4, width: 3, radius: 5 },
    large: { lines: 10, length: 8, width: 4, radius: 8 }
  }

}));

///#source 1 1 /Themes/Default/js/plugins/bootstrap/affix.js
/* ========================================================================
 * Bootstrap: affix.js v3.2.0
 * http://getbootstrap.com/javascript/#affix
 * ========================================================================
 * Copyright 2011-2014 Twitter, Inc.
 * Licensed under MIT (https://github.com/twbs/bootstrap/blob/master/LICENSE)
 * ======================================================================== */


+function ($) {
  'use strict';

  // AFFIX CLASS DEFINITION
  // ======================

  var Affix = function (element, options) {
    this.options = $.extend({}, Affix.DEFAULTS, options)

    this.$target = $(this.options.target)
      .on('scroll.bs.affix.data-api', $.proxy(this.checkPosition, this))
      .on('click.bs.affix.data-api',  $.proxy(this.checkPositionWithEventLoop, this))

    this.$element     = $(element)
    this.affixed      =
    this.unpin        =
    this.pinnedOffset = null

    this.checkPosition()
  }

  Affix.VERSION  = '3.2.0'

  Affix.RESET    = 'affix affix-top affix-bottom'

  Affix.DEFAULTS = {
    offset: 0,
    target: window
  }

  Affix.prototype.getState = function (scrollHeight, height, offsetTop, offsetBottom) {
    var scrollTop    = this.$target.scrollTop()
    var position     = this.$element.offset()
    var targetHeight = this.$target.height()

    if (offsetTop != null && this.affixed == 'top') return scrollTop < offsetTop ? 'top' : false

    if (this.affixed == 'bottom') {
      if (offsetTop != null) return (scrollTop + this.unpin <= position.top) ? false : 'bottom'
      return (scrollTop + targetHeight <= scrollHeight - offsetBottom) ? false : 'bottom'
    }

    var initializing   = this.affixed == null
    var colliderTop    = initializing ? scrollTop : position.top
    var colliderHeight = initializing ? targetHeight : height

    if (offsetTop != null && colliderTop <= offsetTop) return 'top'
    if (offsetBottom != null && (colliderTop + colliderHeight >= scrollHeight - offsetBottom)) return 'bottom'

    return false
  }

  Affix.prototype.getPinnedOffset = function () {
    if (this.pinnedOffset) return this.pinnedOffset
    this.$element.removeClass(Affix.RESET).addClass('affix')
    var scrollTop = this.$target.scrollTop()
    var position  = this.$element.offset()
    return (this.pinnedOffset = position.top - scrollTop)
  }

  Affix.prototype.checkPositionWithEventLoop = function () {
    setTimeout($.proxy(this.checkPosition, this), 1)
  }

  Affix.prototype.checkPosition = function () {
    if (!this.$element.is(':visible')) return

    var height       = this.$element.height()
    var offset       = this.options.offset
    var offsetTop    = offset.top
    var offsetBottom = offset.bottom
    var scrollHeight = $('body').height()

    if (typeof offset != 'object')         offsetBottom = offsetTop = offset
    if (typeof offsetTop == 'function')    offsetTop    = offset.top(this.$element)
    if (typeof offsetBottom == 'function') offsetBottom = offset.bottom(this.$element)

    var affix = this.getState(scrollHeight, height, offsetTop, offsetBottom)

    if (this.affixed != affix) {
      if (this.unpin != null) this.$element.css('top', '')

      var affixType = 'affix' + (affix ? '-' + affix : '')
      var e         = $.Event(affixType + '.bs.affix')

      this.$element.trigger(e)

      if (e.isDefaultPrevented()) return

      this.affixed = affix
      this.unpin = affix == 'bottom' ? this.getPinnedOffset() : null

      this.$element
        .removeClass(Affix.RESET)
        .addClass(affixType)
        .trigger(affixType.replace('affix', 'affixed') + '.bs.affix')
    }

    if (affix == 'bottom') {
      this.$element.offset({
        top: scrollHeight - height - offsetBottom
      })
    }
  }


  // AFFIX PLUGIN DEFINITION
  // =======================

  function Plugin(option) {
    return this.each(function () {
      var $this   = $(this)
      var data    = $this.data('bs.affix')
      var options = typeof option == 'object' && option

      if (!data) $this.data('bs.affix', (data = new Affix(this, options)))
      if (typeof option == 'string') data[option]()
    })
  }

  var old = $.fn.affix

  $.fn.affix             = Plugin
  $.fn.affix.Constructor = Affix


  // AFFIX NO CONFLICT
  // =================

  $.fn.affix.noConflict = function () {
    $.fn.affix = old
    return this
  }


  // AFFIX DATA-API
  // ==============

  $(window).on('load', function () {
    $('[data-spy="affix"]').each(function () {
      var $spy = $(this)
      var data = $spy.data()

      data.offset = data.offset || {}

      if (data.offsetBottom != null) data.offset.bottom = data.offsetBottom
      if (data.offsetTop    != null) data.offset.top    = data.offsetTop

      Plugin.call($spy, data)
    })
  })

}(jQuery);

///#source 1 1 /Themes/Default/js/plugins/bootstrap/collapse.js
/* ========================================================================
 * Bootstrap: collapse.js v3.2.0
 * http://getbootstrap.com/javascript/#collapse
 * ========================================================================
 * Copyright 2011-2014 Twitter, Inc.
 * Licensed under MIT (https://github.com/twbs/bootstrap/blob/master/LICENSE)
 * ======================================================================== */


+function ($) {
  'use strict';

  // COLLAPSE PUBLIC CLASS DEFINITION
  // ================================

  var Collapse = function (element, options) {
    this.$element      = $(element)
    this.options       = $.extend({}, Collapse.DEFAULTS, options)
    this.transitioning = null

    if (this.options.parent) this.$parent = $(this.options.parent)
    if (this.options.toggle) this.toggle()
  }

  Collapse.VERSION  = '3.2.0'

  Collapse.TRANSITION_DURATION = 350

  Collapse.DEFAULTS = {
    toggle: true
  }

  Collapse.prototype.dimension = function () {
    var hasWidth = this.$element.hasClass('width')
    return hasWidth ? 'width' : 'height'
  }

  Collapse.prototype.show = function () {
    if (this.transitioning || this.$element.hasClass('in')) return

    var startEvent = $.Event('show.bs.collapse')
    this.$element.trigger(startEvent)
    if (startEvent.isDefaultPrevented()) return

    var actives = this.$parent && this.$parent.find('> .panel').children('.in, .collapsing')

    if (actives && actives.length) {
      var hasData = actives.data('bs.collapse')
      if (hasData && hasData.transitioning) return
      Plugin.call(actives, 'hide')
      hasData || actives.data('bs.collapse', null)
    }

    var dimension = this.dimension()

    this.$element
      .removeClass('collapse')
      .addClass('collapsing')[dimension](0)
      .attr('aria-expanded', true)

    this.transitioning = 1

    var complete = function () {
      this.$element
        .removeClass('collapsing')
        .addClass('collapse in')[dimension]('')
      this.transitioning = 0
      this.$element
        .trigger('shown.bs.collapse')
    }

    if (!$.support.transition) return complete.call(this)

    var scrollSize = $.camelCase(['scroll', dimension].join('-'))

    this.$element
      .one('bsTransitionEnd', $.proxy(complete, this))
      .emulateTransitionEnd(Collapse.TRANSITION_DURATION)[dimension](this.$element[0][scrollSize])
  }

  Collapse.prototype.hide = function () {
    if (this.transitioning || !this.$element.hasClass('in')) return

    var startEvent = $.Event('hide.bs.collapse')
    this.$element.trigger(startEvent)
    if (startEvent.isDefaultPrevented()) return

    var dimension = this.dimension()

    this.$element[dimension](this.$element[dimension]())[0].offsetHeight

    this.$element
      .addClass('collapsing')
      .removeClass('collapse in')
      .attr('aria-expanded', false)

    this.transitioning = 1

    var complete = function () {
      this.transitioning = 0
      this.$element
        .removeClass('collapsing')
        .addClass('collapse')
        .trigger('hidden.bs.collapse')
    }

    if (!$.support.transition) return complete.call(this)

    this.$element
      [dimension](0)
      .one('bsTransitionEnd', $.proxy(complete, this))
      .emulateTransitionEnd(Collapse.TRANSITION_DURATION)
  }

  Collapse.prototype.toggle = function () {
    this[this.$element.hasClass('in') ? 'hide' : 'show']()
  }


  // COLLAPSE PLUGIN DEFINITION
  // ==========================

  function Plugin(option) {
    return this.each(function () {
      var $this   = $(this)
      var data    = $this.data('bs.collapse')
      var options = $.extend({}, Collapse.DEFAULTS, $this.data(), typeof option == 'object' && option)

      if (!data && options.toggle && option == 'show') options.toggle = false
      if (!data) $this.data('bs.collapse', (data = new Collapse(this, options)))
      if (typeof option == 'string') data[option]()
    })
  }

  var old = $.fn.collapse

  $.fn.collapse             = Plugin
  $.fn.collapse.Constructor = Collapse


  // COLLAPSE NO CONFLICT
  // ====================

  $.fn.collapse.noConflict = function () {
    $.fn.collapse = old
    return this
  }


  // COLLAPSE DATA-API
  // =================

  $(document).on('click.bs.collapse.data-api', '[data-toggle="collapse"]', function (e) {
    var href
    var $this   = $(this)
    var target  = $this.attr('data-target')
        || e.preventDefault()
        || (href = $this.attr('href')) && href.replace(/.*(?=#[^\s]+$)/, '') // strip for ie7
    var $target = $(target)
    var data    = $target.data('bs.collapse')
    var option  = data ? 'toggle' : $this.data()
    var parent  = $this.attr('data-parent')
    var $parent = parent && $(parent)

    if (!data || !data.transitioning) {
      if ($parent) $parent.find('[data-toggle="collapse"][data-parent="' + parent + '"]').not($this).addClass('collapsed').attr('aria-expanded', false)
      var isCollapsed = $target.hasClass('in')
      $this.toggleClass('collapsed', isCollapsed).attr('aria-expanded', !isCollapsed)
    }

    Plugin.call($target, option)
  })

}(jQuery);

///#source 1 1 /Themes/Default/js/plugins/bootstrap/dropdown.js
/* ========================================================================
 * Bootstrap: dropdown.js v3.2.0
 * http://getbootstrap.com/javascript/#dropdowns
 * ========================================================================
 * Copyright 2011-2014 Twitter, Inc.
 * Licensed under MIT (https://github.com/twbs/bootstrap/blob/master/LICENSE)
 * ======================================================================== */


+function ($) {
  'use strict';

  // DROPDOWN CLASS DEFINITION
  // =========================

  var backdrop = '.dropdown-backdrop'
  var toggle   = '[data-toggle="dropdown"]'
  var Dropdown = function (element) {
    $(element).on('click.bs.dropdown', this.toggle)
  }

  Dropdown.VERSION = '3.2.0'

  Dropdown.prototype.toggle = function (e) {
    var $this = $(this)

    if ($this.is('.disabled, :disabled')) return

    var $parent  = getParent($this)
    var isActive = $parent.hasClass('open')

    clearMenus()

    if (!isActive) {
      if ('ontouchstart' in document.documentElement && !$parent.closest('.navbar-nav').length) {
        // if mobile we use a backdrop because click events don't delegate
        $('<div class="dropdown-backdrop"/>').insertAfter($(this)).on('click', clearMenus)
      }

      var relatedTarget = { relatedTarget: this }
      $parent.trigger(e = $.Event('show.bs.dropdown', relatedTarget))

      if (e.isDefaultPrevented()) return

      $this
        .trigger('focus')
        .attr('aria-expanded', 'true')

      $parent
        .toggleClass('open')
        .trigger('shown.bs.dropdown', relatedTarget)
    }

    return false
  }

  Dropdown.prototype.keydown = function (e) {
    if (!/(38|40|27)/.test(e.keyCode)) return

    var $this = $(this)

    e.preventDefault()
    e.stopPropagation()

    if ($this.is('.disabled, :disabled')) return

    var $parent  = getParent($this)
    var isActive = $parent.hasClass('open')

    if (!isActive || (isActive && e.keyCode == 27)) {
      if (e.which == 27) $parent.find(toggle).trigger('focus')
      return $this.trigger('click')
    }

    var desc = ' li:not(.divider):visible a'
    var $items = $parent.find('[role="menu"]' + desc + ', [role="listbox"]' + desc)

    if (!$items.length) return

    var index = $items.index($items.filter(':focus'))

    if (e.keyCode == 38 && index > 0)                 index--                        // up
    if (e.keyCode == 40 && index < $items.length - 1) index++                        // down
    if (!~index)                                      index = 0

    $items.eq(index).trigger('focus')
  }

  function clearMenus(e) {
    if (e && e.which === 3) return
    $(backdrop).remove()
    $(toggle).each(function () {
      var $this         = $(this)
      var $parent       = getParent($this)
      var relatedTarget = { relatedTarget: this }

      if (!$parent.hasClass('open')) return

      $parent.trigger(e = $.Event('hide.bs.dropdown', relatedTarget))

      if (e.isDefaultPrevented()) return

      $this.attr('aria-expanded', 'false')
      $parent.removeClass('open').trigger('hidden.bs.dropdown', relatedTarget)
    })
  }

  function getParent($this) {
    var selector = $this.attr('data-target')

    if (!selector) {
      selector = $this.attr('href')
      selector = selector && /#[A-Za-z]/.test(selector) && selector.replace(/.*(?=#[^\s]*$)/, '') // strip for ie7
    }

    var $parent = selector && $(selector)

    return $parent && $parent.length ? $parent : $this.parent()
  }


  // DROPDOWN PLUGIN DEFINITION
  // ==========================

  function Plugin(option) {
    return this.each(function () {
      var $this = $(this)
      var data  = $this.data('bs.dropdown')

      if (!data) $this.data('bs.dropdown', (data = new Dropdown(this)))
      if (typeof option == 'string') data[option].call($this)
    })
  }

  var old = $.fn.dropdown

  $.fn.dropdown             = Plugin
  $.fn.dropdown.Constructor = Dropdown


  // DROPDOWN NO CONFLICT
  // ====================

  $.fn.dropdown.noConflict = function () {
    $.fn.dropdown = old
    return this
  }


  // APPLY TO STANDARD DROPDOWN ELEMENTS
  // ===================================

  $(document)
    .on('click.bs.dropdown.data-api', clearMenus)
    .on('click.bs.dropdown.data-api', '.dropdown form', function (e) { e.stopPropagation() })
    .on('click.bs.dropdown.data-api', toggle, Dropdown.prototype.toggle)
    .on('keydown.bs.dropdown.data-api', toggle + ', [role="menu"], [role="listbox"]', Dropdown.prototype.keydown)

}(jQuery);

///#source 1 1 /Themes/Default/js/plugins/bootstrap/modal.js
/* ========================================================================
 * Bootstrap: modal.js v3.2.0
 * http://getbootstrap.com/javascript/#modals
 * ========================================================================
 * Copyright 2011-2014 Twitter, Inc.
 * Licensed under MIT (https://github.com/twbs/bootstrap/blob/master/LICENSE)
 * ======================================================================== */


+function ($) {
  'use strict';

  // MODAL CLASS DEFINITION
  // ======================

  var Modal = function (element, options) {
    this.options        = options
    this.$body          = $(document.body)
    this.$element       = $(element)
    this.$backdrop      =
    this.isShown        = null
    this.scrollbarWidth = 0

    if (this.options.remote) {
      this.$element
        .find('.modal-content')
        .load(this.options.remote, $.proxy(function () {
          this.$element.trigger('loaded.bs.modal')
        }, this))
    }
  }

  Modal.VERSION  = '3.2.0'

  Modal.TRANSITION_DURATION = 300
  Modal.BACKDROP_TRANSITION_DURATION = 150

  Modal.DEFAULTS = {
    backdrop: true,
    keyboard: true,
    show: true
  }

  Modal.prototype.toggle = function (_relatedTarget) {
    return this.isShown ? this.hide() : this.show(_relatedTarget)
  }

  Modal.prototype.show = function (_relatedTarget) {
    var that = this
    var e    = $.Event('show.bs.modal', { relatedTarget: _relatedTarget })

    this.$element.trigger(e)

    if (this.isShown || e.isDefaultPrevented()) return

    this.isShown = true

    this.checkScrollbar()
    this.$body.addClass('modal-open')

    this.setScrollbar()
    this.escape()

    this.$element.on('click.dismiss.bs.modal', '[data-dismiss="modal"]', $.proxy(this.hide, this))

    this.backdrop(function () {
      var transition = $.support.transition && that.$element.hasClass('fade')

      if (!that.$element.parent().length) {
        that.$element.appendTo(that.$body) // don't move modals dom position
      }

      that.$element
        .show()
        .scrollTop(0)

      if (transition) {
        that.$element[0].offsetWidth // force reflow
      }

      that.$element
        .addClass('in')
        .attr('aria-hidden', false)

      that.enforceFocus()

      var e = $.Event('shown.bs.modal', { relatedTarget: _relatedTarget })

      transition ?
        that.$element.find('.modal-dialog') // wait for modal to slide in
          .one('bsTransitionEnd', function () {
            that.$element.trigger('focus').trigger(e)
          })
          .emulateTransitionEnd(Modal.TRANSITION_DURATION) :
        that.$element.trigger('focus').trigger(e)
    })
  }

  Modal.prototype.hide = function (e) {
    if (e) e.preventDefault()

    e = $.Event('hide.bs.modal')

    this.$element.trigger(e)

    if (!this.isShown || e.isDefaultPrevented()) return

    this.isShown = false

    this.$body.removeClass('modal-open')

    this.resetScrollbar()
    this.escape()

    $(document).off('focusin.bs.modal')

    this.$element
      .removeClass('in')
      .attr('aria-hidden', true)
      .off('click.dismiss.bs.modal')

    $.support.transition && this.$element.hasClass('fade') ?
      this.$element
        .one('bsTransitionEnd', $.proxy(this.hideModal, this))
        .emulateTransitionEnd(Modal.TRANSITION_DURATION) :
      this.hideModal()
  }

  Modal.prototype.enforceFocus = function () {
    $(document)
      .off('focusin.bs.modal') // guard against infinite focus loop
      .on('focusin.bs.modal', $.proxy(function (e) {
        if (this.$element[0] !== e.target && !this.$element.has(e.target).length) {
          this.$element.trigger('focus')
        }
      }, this))
  }

  Modal.prototype.escape = function () {
    if (this.isShown && this.options.keyboard) {
      this.$element.on('keydown.dismiss.bs.modal', $.proxy(function (e) {
        e.which == 27 && this.hide()
      }, this))
    } else if (!this.isShown) {
      this.$element.off('keydown.dismiss.bs.modal')
    }
  }

  Modal.prototype.hideModal = function () {
    var that = this
    this.$element.hide()
    this.backdrop(function () {
      that.$element.trigger('hidden.bs.modal')
    })
  }

  Modal.prototype.removeBackdrop = function () {
    this.$backdrop && this.$backdrop.remove()
    this.$backdrop = null
  }

  Modal.prototype.backdrop = function (callback) {
    var that = this
    var animate = this.$element.hasClass('fade') ? 'fade' : ''

    if (this.isShown && this.options.backdrop) {
      var doAnimate = $.support.transition && animate

      this.$backdrop = $('<div class="modal-backdrop ' + animate + '" />')
        .appendTo(this.$body)

      this.$element.on('click.dismiss.bs.modal', $.proxy(function (e) {
        if (e.target !== e.currentTarget) return
        this.options.backdrop == 'static'
          ? this.$element[0].focus.call(this.$element[0])
          : this.hide.call(this)
      }, this))

      if (doAnimate) this.$backdrop[0].offsetWidth // force reflow

      this.$backdrop.addClass('in')

      if (!callback) return

      doAnimate ?
        this.$backdrop
          .one('bsTransitionEnd', callback)
          .emulateTransitionEnd(Modal.BACKDROP_TRANSITION_DURATION) :
        callback()

    } else if (!this.isShown && this.$backdrop) {
      this.$backdrop.removeClass('in')

      var callbackRemove = function () {
        that.removeBackdrop()
        callback && callback()
      }
      $.support.transition && this.$element.hasClass('fade') ?
        this.$backdrop
          .one('bsTransitionEnd', callbackRemove)
          .emulateTransitionEnd(Modal.BACKDROP_TRANSITION_DURATION) :
        callbackRemove()

    } else if (callback) {
      callback()
    }
  }

  Modal.prototype.checkScrollbar = function () {
    this.scrollbarWidth = this.measureScrollbar()
  }

  Modal.prototype.setScrollbar = function () {
    var bodyPad = parseInt((this.$body.css('padding-right') || 0), 10)
    if (this.scrollbarWidth) this.$body.css('padding-right', bodyPad + this.scrollbarWidth)
  }

  Modal.prototype.resetScrollbar = function () {
    this.$body.css('padding-right', '')
  }

  Modal.prototype.measureScrollbar = function () { // thx walsh
    if (document.body.clientWidth >= window.innerWidth) return 0
    var scrollDiv = document.createElement('div')
    scrollDiv.className = 'modal-scrollbar-measure'
    this.$body.append(scrollDiv)
    var scrollbarWidth = scrollDiv.offsetWidth - scrollDiv.clientWidth
    this.$body[0].removeChild(scrollDiv)
    return scrollbarWidth
  }


  // MODAL PLUGIN DEFINITION
  // =======================

  function Plugin(option, _relatedTarget) {
    return this.each(function () {
      var $this   = $(this)
      var data    = $this.data('bs.modal')
      var options = $.extend({}, Modal.DEFAULTS, $this.data(), typeof option == 'object' && option)

      if (!data) $this.data('bs.modal', (data = new Modal(this, options)))
      if (typeof option == 'string') data[option](_relatedTarget)
      else if (options.show) data.show(_relatedTarget)
    })
  }

  var old = $.fn.modal

  $.fn.modal             = Plugin
  $.fn.modal.Constructor = Modal


  // MODAL NO CONFLICT
  // =================

  $.fn.modal.noConflict = function () {
    $.fn.modal = old
    return this
  }


  // MODAL DATA-API
  // ==============

  $(document).on('click.bs.modal.data-api', '[data-toggle="modal"]', function (e) {
    var $this   = $(this)
    var href    = $this.attr('href')
    var $target = $($this.attr('data-target') || (href && href.replace(/.*(?=#[^\s]+$)/, ''))) // strip for ie7
    var option  = $target.data('bs.modal') ? 'toggle' : $.extend({ remote: !/#/.test(href) && href }, $target.data(), $this.data())

    if ($this.is('a')) e.preventDefault()

    $target.one('show.bs.modal', function (showEvent) {
      if (showEvent.isDefaultPrevented()) return // only register focus restorer if modal will actually get shown
      $target.one('hidden.bs.modal', function () {
        $this.is(':visible') && $this.trigger('focus')
      })
    })
    Plugin.call($target, option, this)
  })

}(jQuery);

///#source 1 1 /Themes/Default/js/plugins/bootstrap/tooltip.js
/* ========================================================================
 * Bootstrap: tooltip.js v3.2.0
 * http://getbootstrap.com/javascript/#tooltip
 * Inspired by the original jQuery.tipsy by Jason Frame
 * ========================================================================
 * Copyright 2011-2014 Twitter, Inc.
 * Licensed under MIT (https://github.com/twbs/bootstrap/blob/master/LICENSE)
 * ======================================================================== */


+function ($) {
  'use strict';

  // TOOLTIP PUBLIC CLASS DEFINITION
  // ===============================

  var Tooltip = function (element, options) {
    this.type       =
    this.options    =
    this.enabled    =
    this.timeout    =
    this.hoverState =
    this.$element   = null

    this.init('tooltip', element, options)
  }

  Tooltip.VERSION  = '3.2.0'

  Tooltip.TRANSITION_DURATION = 150

  Tooltip.DEFAULTS = {
    animation: true,
    placement: 'top',
    selector: false,
    template: '<div class="tooltip" role="tooltip"><div class="tooltip-arrow"></div><div class="tooltip-inner"></div></div>',
    trigger: 'hover focus',
    title: '',
    delay: 0,
    html: false,
    container: false,
    viewport: {
      selector: 'body',
      padding: 0
    }
  }

  Tooltip.prototype.init = function (type, element, options) {
    this.enabled   = true
    this.type      = type
    this.$element  = $(element)
    this.options   = this.getOptions(options)
    this.$viewport = this.options.viewport && $(this.options.viewport.selector || this.options.viewport)

    var triggers = this.options.trigger.split(' ')

    for (var i = triggers.length; i--;) {
      var trigger = triggers[i]

      if (trigger == 'click') {
        this.$element.on('click.' + this.type, this.options.selector, $.proxy(this.toggle, this))
      } else if (trigger != 'manual') {
        var eventIn  = trigger == 'hover' ? 'mouseenter' : 'focusin'
        var eventOut = trigger == 'hover' ? 'mouseleave' : 'focusout'

        this.$element.on(eventIn  + '.' + this.type, this.options.selector, $.proxy(this.enter, this))
        this.$element.on(eventOut + '.' + this.type, this.options.selector, $.proxy(this.leave, this))
      }
    }

    this.options.selector ?
      (this._options = $.extend({}, this.options, { trigger: 'manual', selector: '' })) :
      this.fixTitle()
  }

  Tooltip.prototype.getDefaults = function () {
    return Tooltip.DEFAULTS
  }

  Tooltip.prototype.getOptions = function (options) {
    options = $.extend({}, this.getDefaults(), this.$element.data(), options)

    if (options.delay && typeof options.delay == 'number') {
      options.delay = {
        show: options.delay,
        hide: options.delay
      }
    }

    return options
  }

  Tooltip.prototype.getDelegateOptions = function () {
    var options  = {}
    var defaults = this.getDefaults()

    this._options && $.each(this._options, function (key, value) {
      if (defaults[key] != value) options[key] = value
    })

    return options
  }

  Tooltip.prototype.enter = function (obj) {
    var self = obj instanceof this.constructor ?
      obj : $(obj.currentTarget).data('bs.' + this.type)

    if (self && self.$tip && self.$tip.is(':visible')) {
      self.hoverState = 'in'
      return
    }

    if (!self) {
      self = new this.constructor(obj.currentTarget, this.getDelegateOptions())
      $(obj.currentTarget).data('bs.' + this.type, self)
    }

    clearTimeout(self.timeout)

    self.hoverState = 'in'

    if (!self.options.delay || !self.options.delay.show) return self.show()

    self.timeout = setTimeout(function () {
      if (self.hoverState == 'in') self.show()
    }, self.options.delay.show)
  }

  Tooltip.prototype.leave = function (obj) {
    var self = obj instanceof this.constructor ?
      obj : $(obj.currentTarget).data('bs.' + this.type)

    if (!self) {
      self = new this.constructor(obj.currentTarget, this.getDelegateOptions())
      $(obj.currentTarget).data('bs.' + this.type, self)
    }

    clearTimeout(self.timeout)

    self.hoverState = 'out'

    if (!self.options.delay || !self.options.delay.hide) return self.hide()

    self.timeout = setTimeout(function () {
      if (self.hoverState == 'out') self.hide()
    }, self.options.delay.hide)
  }

  Tooltip.prototype.show = function () {
    var e = $.Event('show.bs.' + this.type)

    if (this.hasContent() && this.enabled) {
      this.$element.trigger(e)

      var inDom = $.contains(this.$element[0].ownerDocument.documentElement, this.$element[0])
      if (e.isDefaultPrevented() || !inDom) return
      var that = this

      var $tip = this.tip()

      var tipId = this.getUID(this.type)

      this.setContent()
      $tip.attr('id', tipId)
      this.$element.attr('aria-describedby', tipId)

      if (this.options.animation) $tip.addClass('fade')

      var placement = typeof this.options.placement == 'function' ?
        this.options.placement.call(this, $tip[0], this.$element[0]) :
        this.options.placement

      var autoToken = /\s?auto?\s?/i
      var autoPlace = autoToken.test(placement)
      if (autoPlace) placement = placement.replace(autoToken, '') || 'top'

      $tip
        .detach()
        .css({ top: 0, left: 0, display: 'block' })
        .addClass(placement)
        .data('bs.' + this.type, this)

      this.options.container ? $tip.appendTo(this.options.container) : $tip.insertAfter(this.$element)

      var pos          = this.getPosition()
      var actualWidth  = $tip[0].offsetWidth
      var actualHeight = $tip[0].offsetHeight

      if (autoPlace) {
        var orgPlacement = placement
        var $parent      = this.$element.parent()
        var parentDim    = this.getPosition($parent)

        placement = placement == 'bottom' && pos.top   + pos.height       + actualHeight - parentDim.scroll > parentDim.height ? 'top'    :
                    placement == 'top'    && pos.top   - parentDim.scroll - actualHeight < parentDim.top                       ? 'bottom' :
                    placement == 'right'  && pos.right + actualWidth      > parentDim.width                                    ? 'left'   :
                    placement == 'left'   && pos.left  - actualWidth      < parentDim.left                                     ? 'right'  :
                    placement

        $tip
          .removeClass(orgPlacement)
          .addClass(placement)
      }

      var calculatedOffset = this.getCalculatedOffset(placement, pos, actualWidth, actualHeight)

      this.applyPlacement(calculatedOffset, placement)

      var complete = function () {
        that.$element.trigger('shown.bs.' + that.type)
        that.hoverState = null
      }

      $.support.transition && this.$tip.hasClass('fade') ?
        $tip
          .one('bsTransitionEnd', complete)
          .emulateTransitionEnd(Tooltip.TRANSITION_DURATION) :
        complete()
    }
  }

  Tooltip.prototype.applyPlacement = function (offset, placement) {
    var $tip   = this.tip()
    var width  = $tip[0].offsetWidth
    var height = $tip[0].offsetHeight

    // manually read margins because getBoundingClientRect includes difference
    var marginTop = parseInt($tip.css('margin-top'), 10)
    var marginLeft = parseInt($tip.css('margin-left'), 10)

    // we must check for NaN for ie 8/9
    if (isNaN(marginTop))  marginTop  = 0
    if (isNaN(marginLeft)) marginLeft = 0

    offset.top  = offset.top  + marginTop
    offset.left = offset.left + marginLeft

    // $.fn.offset doesn't round pixel values
    // so we use setOffset directly with our own function B-0
    $.offset.setOffset($tip[0], $.extend({
      using: function (props) {
        $tip.css({
          top: Math.round(props.top),
          left: Math.round(props.left)
        })
      }
    }, offset), 0)

    $tip.addClass('in')

    // check to see if placing tip in new offset caused the tip to resize itself
    var actualWidth  = $tip[0].offsetWidth
    var actualHeight = $tip[0].offsetHeight

    if (placement == 'top' && actualHeight != height) {
      offset.top = offset.top + height - actualHeight
    }

    var delta = this.getViewportAdjustedDelta(placement, offset, actualWidth, actualHeight)

    if (delta.left) offset.left += delta.left
    else offset.top += delta.top

    var isVertical          = /top|bottom/.test(placement)
    var arrowDelta          = isVertical ? delta.left * 2 - width + actualWidth : delta.top * 2 - height + actualHeight
    var arrowOffsetPosition = isVertical ? 'offsetWidth' : 'offsetHeight'

    $tip.offset(offset)
    this.replaceArrow(arrowDelta, $tip[0][arrowOffsetPosition], isVertical)
  }

  Tooltip.prototype.replaceArrow = function (delta, dimension, isHorizontal) {
    this.arrow()
      .css(isHorizontal ? 'left' : 'top', 50 * (1 - delta / dimension) + '%')
      .css(isHorizontal ? 'top' : 'left', '')
  }

  Tooltip.prototype.setContent = function () {
    var $tip  = this.tip()
    var title = this.getTitle()

    $tip.find('.tooltip-inner')[this.options.html ? 'html' : 'text'](title)
    $tip.removeClass('fade in top bottom left right')
  }

  Tooltip.prototype.hide = function (callback) {
    var that = this
    var $tip = this.tip()
    var e    = $.Event('hide.bs.' + this.type)

    function complete() {
      if (that.hoverState != 'in') $tip.detach()
      that.$element
        .removeAttr('aria-describedby')
        .trigger('hidden.bs.' + that.type)
      callback && callback()
    }

    this.$element.trigger(e)

    if (e.isDefaultPrevented()) return

    $tip.removeClass('in')

    $.support.transition && this.$tip.hasClass('fade') ?
      $tip
        .one('bsTransitionEnd', complete)
        .emulateTransitionEnd(Tooltip.TRANSITION_DURATION) :
      complete()

    this.hoverState = null

    return this
  }

  Tooltip.prototype.fixTitle = function () {
    var $e = this.$element
    if ($e.attr('title') || typeof ($e.attr('data-original-title')) != 'string') {
      $e.attr('data-original-title', $e.attr('title') || '').attr('title', '')
    }
  }

  Tooltip.prototype.hasContent = function () {
    return this.getTitle()
  }

  Tooltip.prototype.getPosition = function ($element) {
    $element   = $element || this.$element

    var el     = $element[0]
    var isBody = el.tagName == 'BODY'
    var isSvg  = window.SVGElement && el instanceof window.SVGElement

    var elRect    = el.getBoundingClientRect()
    if (elRect.width == null) {
      // width and height are missing in IE8, so compute them manually; see https://github.com/twbs/bootstrap/issues/14093
      elRect = $.extend({}, elRect, { width: elRect.right - elRect.left, height: elRect.bottom - elRect.top })
    }
    var elOffset  = isBody ? { top: 0, left: 0 } : $element.offset()
    var scroll    = { scroll: isBody ? document.documentElement.scrollTop || document.body.scrollTop : $element.scrollTop() }
    var outerDims = isSvg ? {} : {
      width:  isBody ? $(window).width()  : $element.outerWidth(),
      height: isBody ? $(window).height() : $element.outerHeight()
    }

    return $.extend({}, elRect, scroll, outerDims, elOffset)
  }

  Tooltip.prototype.getCalculatedOffset = function (placement, pos, actualWidth, actualHeight) {
    return placement == 'bottom' ? { top: pos.top + pos.height,   left: pos.left + pos.width / 2 - actualWidth / 2  } :
           placement == 'top'    ? { top: pos.top - actualHeight, left: pos.left + pos.width / 2 - actualWidth / 2  } :
           placement == 'left'   ? { top: pos.top + pos.height / 2 - actualHeight / 2, left: pos.left - actualWidth } :
        /* placement == 'right' */ { top: pos.top + pos.height / 2 - actualHeight / 2, left: pos.left + pos.width   }

  }

  Tooltip.prototype.getViewportAdjustedDelta = function (placement, pos, actualWidth, actualHeight) {
    var delta = { top: 0, left: 0 }
    if (!this.$viewport) return delta

    var viewportPadding = this.options.viewport && this.options.viewport.padding || 0
    var viewportDimensions = this.getPosition(this.$viewport)

    if (/right|left/.test(placement)) {
      var topEdgeOffset    = pos.top - viewportPadding - viewportDimensions.scroll
      var bottomEdgeOffset = pos.top + viewportPadding - viewportDimensions.scroll + actualHeight
      if (topEdgeOffset < viewportDimensions.top) { // top overflow
        delta.top = viewportDimensions.top - topEdgeOffset
      } else if (bottomEdgeOffset > viewportDimensions.top + viewportDimensions.height) { // bottom overflow
        delta.top = viewportDimensions.top + viewportDimensions.height - bottomEdgeOffset
      }
    } else {
      var leftEdgeOffset  = pos.left - viewportPadding
      var rightEdgeOffset = pos.left + viewportPadding + actualWidth
      if (leftEdgeOffset < viewportDimensions.left) { // left overflow
        delta.left = viewportDimensions.left - leftEdgeOffset
      } else if (rightEdgeOffset > viewportDimensions.width) { // right overflow
        delta.left = viewportDimensions.left + viewportDimensions.width - rightEdgeOffset
      }
    }

    return delta
  }

  Tooltip.prototype.getTitle = function () {
    var title
    var $e = this.$element
    var o  = this.options

    title = $e.attr('data-original-title')
      || (typeof o.title == 'function' ? o.title.call($e[0]) :  o.title)

    return title
  }

  Tooltip.prototype.getUID = function (prefix) {
    do prefix += ~~(Math.random() * 1000000)
    while (document.getElementById(prefix))
    return prefix
  }

  Tooltip.prototype.tip = function () {
    return (this.$tip = this.$tip || $(this.options.template))
  }

  Tooltip.prototype.arrow = function () {
    return (this.$arrow = this.$arrow || this.tip().find('.tooltip-arrow'))
  }

  Tooltip.prototype.enable = function () {
    this.enabled = true
  }

  Tooltip.prototype.disable = function () {
    this.enabled = false
  }

  Tooltip.prototype.toggleEnabled = function () {
    this.enabled = !this.enabled
  }

  Tooltip.prototype.toggle = function (e) {
    var self = this
    if (e) {
      self = $(e.currentTarget).data('bs.' + this.type)
      if (!self) {
        self = new this.constructor(e.currentTarget, this.getDelegateOptions())
        $(e.currentTarget).data('bs.' + this.type, self)
      }
    }

    self.tip().hasClass('in') ? self.leave(self) : self.enter(self)
  }

  Tooltip.prototype.destroy = function () {
    var that = this
    clearTimeout(this.timeout)
    this.hide(function () {
      that.$element.off('.' + that.type).removeData('bs.' + that.type)
    })
  }


  // TOOLTIP PLUGIN DEFINITION
  // =========================

  function Plugin(option) {
    return this.each(function () {
      var $this   = $(this)
      var data    = $this.data('bs.tooltip')
      var options = typeof option == 'object' && option

      if (!data && option == 'destroy') return
      if (!data) $this.data('bs.tooltip', (data = new Tooltip(this, options)))
      if (typeof option == 'string') data[option]()
    })
  }

  var old = $.fn.tooltip

  $.fn.tooltip             = Plugin
  $.fn.tooltip.Constructor = Tooltip


  // TOOLTIP NO CONFLICT
  // ===================

  $.fn.tooltip.noConflict = function () {
    $.fn.tooltip = old
    return this
  }

}(jQuery);

///#source 1 1 /Themes/Default/js/plugins/bootstrap/popover.js
/* ========================================================================
 * Bootstrap: popover.js v3.2.0
 * http://getbootstrap.com/javascript/#popovers
 * ========================================================================
 * Copyright 2011-2014 Twitter, Inc.
 * Licensed under MIT (https://github.com/twbs/bootstrap/blob/master/LICENSE)
 * ======================================================================== */


+function ($) {
  'use strict';

  // POPOVER PUBLIC CLASS DEFINITION
  // ===============================

  var Popover = function (element, options) {
    this.init('popover', element, options)
  }

  if (!$.fn.tooltip) throw new Error('Popover requires tooltip.js')

  Popover.VERSION  = '3.2.0'

  Popover.DEFAULTS = $.extend({}, $.fn.tooltip.Constructor.DEFAULTS, {
    placement: 'right',
    trigger: 'click',
    content: '',
    template: '<div class="popover" role="tooltip"><div class="arrow"></div><h3 class="popover-title"></h3><div class="popover-content"></div></div>'
  })


  // NOTE: POPOVER EXTENDS tooltip.js
  // ================================

  Popover.prototype = $.extend({}, $.fn.tooltip.Constructor.prototype)

  Popover.prototype.constructor = Popover

  Popover.prototype.getDefaults = function () {
    return Popover.DEFAULTS
  }

  Popover.prototype.setContent = function () {
    var $tip    = this.tip()
    var title   = this.getTitle()
    var content = this.getContent()

    $tip.find('.popover-title')[this.options.html ? 'html' : 'text'](title)
    $tip.find('.popover-content').children().detach().end()[ // we use append for html objects to maintain js events
      this.options.html ? (typeof content == 'string' ? 'html' : 'append') : 'text'
    ](content)

    $tip.removeClass('fade top bottom left right in')

    // IE8 doesn't accept hiding via the `:empty` pseudo selector, we have to do
    // this manually by checking the contents.
    if (!$tip.find('.popover-title').html()) $tip.find('.popover-title').hide()
  }

  Popover.prototype.hasContent = function () {
    return this.getTitle() || this.getContent()
  }

  Popover.prototype.getContent = function () {
    var $e = this.$element
    var o  = this.options

    return $e.attr('data-content')
      || (typeof o.content == 'function' ?
            o.content.call($e[0]) :
            o.content)
  }

  Popover.prototype.arrow = function () {
    return (this.$arrow = this.$arrow || this.tip().find('.arrow'))
  }

  Popover.prototype.tip = function () {
    if (!this.$tip) this.$tip = $(this.options.template)
    return this.$tip
  }


  // POPOVER PLUGIN DEFINITION
  // =========================

  function Plugin(option) {
    return this.each(function () {
      var $this   = $(this)
      var data    = $this.data('bs.popover')
      var options = typeof option == 'object' && option

      if (!data && option == 'destroy') return
      if (!data) $this.data('bs.popover', (data = new Popover(this, options)))
      if (typeof option == 'string') data[option]()
    })
  }

  var old = $.fn.popover

  $.fn.popover             = Plugin
  $.fn.popover.Constructor = Popover


  // POPOVER NO CONFLICT
  // ===================

  $.fn.popover.noConflict = function () {
    $.fn.popover = old
    return this
  }

}(jQuery);

///#source 1 1 /Themes/Default/js/plugins/bootstrap/scrollspy.js
/* ========================================================================
 * Bootstrap: scrollspy.js v3.2.0
 * http://getbootstrap.com/javascript/#scrollspy
 * ========================================================================
 * Copyright 2011-2014 Twitter, Inc.
 * Licensed under MIT (https://github.com/twbs/bootstrap/blob/master/LICENSE)
 * ======================================================================== */


+function ($) {
  'use strict';

  // SCROLLSPY CLASS DEFINITION
  // ==========================

  function ScrollSpy(element, options) {
    var process  = $.proxy(this.process, this)

    this.$body          = $('body')
    this.$scrollElement = $(element).is('body') ? $(window) : $(element)
    this.options        = $.extend({}, ScrollSpy.DEFAULTS, options)
    this.selector       = (this.options.target || '') + ' .nav li > a'
    this.offsets        = []
    this.targets        = []
    this.activeTarget   = null
    this.scrollHeight   = 0

    this.$scrollElement.on('scroll.bs.scrollspy', process)
    this.refresh()
    this.process()
  }

  ScrollSpy.VERSION  = '3.2.0'

  ScrollSpy.DEFAULTS = {
    offset: 10
  }

  ScrollSpy.prototype.getScrollHeight = function () {
    return this.$scrollElement[0].scrollHeight || Math.max(this.$body[0].scrollHeight, document.documentElement.scrollHeight)
  }

  ScrollSpy.prototype.refresh = function () {
    var offsetMethod = 'offset'
    var offsetBase   = 0

    if (!$.isWindow(this.$scrollElement[0])) {
      offsetMethod = 'position'
      offsetBase   = this.$scrollElement.scrollTop()
    }

    this.offsets = []
    this.targets = []
    this.scrollHeight = this.getScrollHeight()

    var self     = this

    this.$body
      .find(this.selector)
      .map(function () {
        var $el   = $(this)
        var href  = $el.data('target') || $el.attr('href')
        var $href = /^#./.test(href) && $(href)

        return ($href
          && $href.length
          && $href.is(':visible')
          && $el.is(':visible')
          && [[$href[offsetMethod]().top + offsetBase, href]]) || null
      })
      .sort(function (a, b) { return a[0] - b[0] })
      .each(function () {
        self.offsets.push(this[0])
        self.targets.push(this[1])
      })
  }

  ScrollSpy.prototype.process = function () {
    var scrollTop    = this.$scrollElement.scrollTop() + this.options.offset
    var scrollHeight = this.getScrollHeight()
    var maxScroll    = this.options.offset + scrollHeight - this.$scrollElement.height()
    var offsets      = this.offsets
    var targets      = this.targets
    var activeTarget = this.activeTarget
    var i

    if (this.scrollHeight != scrollHeight) {
      this.refresh()
    }

    if (scrollTop >= maxScroll) {
      return activeTarget != (i = targets[targets.length - 1]) && this.activate(i)
    }

    if (activeTarget && scrollTop <= offsets[0]) {
      return activeTarget != (i = targets[0]) && this.activate(i)
    }

    for (i = offsets.length; i--;) {
      activeTarget != targets[i]
        && scrollTop >= offsets[i]
        && (!offsets[i + 1] || scrollTop <= offsets[i + 1])
        && this.activate(targets[i])
    }
  }

  ScrollSpy.prototype.activate = function (target) {
    this.activeTarget = target

    $(this.selector)
      .parentsUntil(this.options.target, '.active')
      .removeClass('active')

    var selector = this.selector +
        '[data-target="' + target + '"],' +
        this.selector + '[href="' + target + '"]'

    var active = $(selector)
      .parents('li')
      .addClass('active')

    if (active.parent('.dropdown-menu').length) {
      active = active
        .closest('li.dropdown')
        .addClass('active')
    }

    active.trigger('activate.bs.scrollspy')
  }


  // SCROLLSPY PLUGIN DEFINITION
  // ===========================

  function Plugin(option) {
    return this.each(function () {
      var $this   = $(this)
      var data    = $this.data('bs.scrollspy')
      var options = typeof option == 'object' && option

      if (!data) $this.data('bs.scrollspy', (data = new ScrollSpy(this, options)))
      if (typeof option == 'string') data[option]()
    })
  }

  var old = $.fn.scrollspy

  $.fn.scrollspy             = Plugin
  $.fn.scrollspy.Constructor = ScrollSpy


  // SCROLLSPY NO CONFLICT
  // =====================

  $.fn.scrollspy.noConflict = function () {
    $.fn.scrollspy = old
    return this
  }


  // SCROLLSPY DATA-API
  // ==================

  $(window).on('load.bs.scrollspy.data-api', function () {
    $('[data-spy="scroll"]').each(function () {
      var $spy = $(this)
      Plugin.call($spy, $spy.data())
    })
  })

}(jQuery);

///#source 1 1 /Themes/Default/js/plugins/bootstrap/tab.js
/* ========================================================================
 * Bootstrap: tab.js v3.2.0
 * http://getbootstrap.com/javascript/#tabs
 * ========================================================================
 * Copyright 2011-2014 Twitter, Inc.
 * Licensed under MIT (https://github.com/twbs/bootstrap/blob/master/LICENSE)
 * ======================================================================== */


+function ($) {
  'use strict';

  // TAB CLASS DEFINITION
  // ====================

  var Tab = function (element) {
    this.element = $(element)
  }

  Tab.VERSION = '3.2.0'

  Tab.TRANSITION_DURATION = 150

  Tab.prototype.show = function () {
    var $this    = this.element
    var $ul      = $this.closest('ul:not(.dropdown-menu)')
    var selector = $this.data('target')

    if (!selector) {
      selector = $this.attr('href')
      selector = selector && selector.replace(/.*(?=#[^\s]*$)/, '') // strip for ie7
    }

    if ($this.parent('li').hasClass('active')) return

    var previous = $ul.find('.active:last a')[0]
    var e        = $.Event('show.bs.tab', {
      relatedTarget: previous
    })

    $this.trigger(e)

    if (e.isDefaultPrevented()) return

    var $target = $(selector)

    this.activate($this.closest('li'), $ul)
    this.activate($target, $target.parent(), function () {
      $this.trigger({
        type: 'shown.bs.tab',
        relatedTarget: previous
      })
    })
  }

  Tab.prototype.activate = function (element, container, callback) {
    var $active    = container.find('> .active')
    var transition = callback
      && $.support.transition
      && (($active.length && $active.hasClass('fade')) || !!container.find('> .fade').length)

    function next() {
      $active
        .removeClass('active')
        .find('> .dropdown-menu > .active')
        .removeClass('active')

      element.addClass('active')

      if (transition) {
        element[0].offsetWidth // reflow for transition
        element.addClass('in')
      } else {
        element.removeClass('fade')
      }

      if (element.parent('.dropdown-menu')) {
        element.closest('li.dropdown').addClass('active')
      }

      callback && callback()
    }

    $active.length && transition ?
      $active
        .one('bsTransitionEnd', next)
        .emulateTransitionEnd(Tab.TRANSITION_DURATION) :
      next()

    $active.removeClass('in')
  }


  // TAB PLUGIN DEFINITION
  // =====================

  function Plugin(option) {
    return this.each(function () {
      var $this = $(this)
      var data  = $this.data('bs.tab')

      if (!data) $this.data('bs.tab', (data = new Tab(this)))
      if (typeof option == 'string') data[option]()
    })
  }

  var old = $.fn.tab

  $.fn.tab             = Plugin
  $.fn.tab.Constructor = Tab


  // TAB NO CONFLICT
  // ===============

  $.fn.tab.noConflict = function () {
    $.fn.tab = old
    return this
  }


  // TAB DATA-API
  // ============

  $(document).on('click.bs.tab.data-api', '[data-toggle="tab"], [data-toggle="pill"]', function (e) {
    e.preventDefault()
    Plugin.call($(this), 'show')
  })

}(jQuery);

///#source 1 1 /Themes/Default/js/plugins/bootstrap/transition.js
/* ========================================================================
 * Bootstrap: transition.js v3.2.0
 * http://getbootstrap.com/javascript/#transitions
 * ========================================================================
 * Copyright 2011-2014 Twitter, Inc.
 * Licensed under MIT (https://github.com/twbs/bootstrap/blob/master/LICENSE)
 * ======================================================================== */


+function ($) {
  'use strict';

  // CSS TRANSITION SUPPORT (Shoutout: http://www.modernizr.com/)
  // ============================================================

  function transitionEnd() {
    var el = document.createElement('bootstrap')

    var transEndEventNames = {
      WebkitTransition : 'webkitTransitionEnd',
      MozTransition    : 'transitionend',
      OTransition      : 'oTransitionEnd otransitionend',
      transition       : 'transitionend'
    }

    for (var name in transEndEventNames) {
      if (el.style[name] !== undefined) {
        return { end: transEndEventNames[name] }
      }
    }

    return false // explicit for ie8 (  ._.)
  }

  // http://blog.alexmaccaw.com/css-transitions
  $.fn.emulateTransitionEnd = function (duration) {
    var called = false
    var $el = this
    $(this).one('bsTransitionEnd', function () { called = true })
    var callback = function () { if (!called) $($el).trigger($.support.transition.end) }
    setTimeout(callback, duration)
    return this
  }

  $(function () {
    $.support.transition = transitionEnd()

    if (!$.support.transition) return

    $.event.special.bsTransitionEnd = {
      bindType: $.support.transition.end,
      delegateType: $.support.transition.end,
      handle: function (e) {
        if ($(e.target).is(this)) return e.handleObj.handler.apply(this, arguments)
      }
    }
  })

}(jQuery);

///#source 1 1 /Themes/Default/js/plugins/bootstrap/carousel.js
/* ========================================================================
 * Bootstrap: carousel.js v3.2.0
 * http://getbootstrap.com/javascript/#carousel
 * ========================================================================
 * Copyright 2011-2014 Twitter, Inc.
 * Licensed under MIT (https://github.com/twbs/bootstrap/blob/master/LICENSE)
 * ======================================================================== */


+function ($) {
  'use strict';

  // CAROUSEL CLASS DEFINITION
  // =========================

  var Carousel = function (element, options) {
    this.$element    = $(element).on('keydown.bs.carousel', $.proxy(this.keydown, this))
    this.$indicators = this.$element.find('.carousel-indicators')
    this.options     = options
    this.paused      =
    this.sliding     =
    this.interval    =
    this.$active     =
    this.$items      = null

    this.options.pause == 'hover' && this.$element
      .on('mouseenter.bs.carousel', $.proxy(this.pause, this))
      .on('mouseleave.bs.carousel', $.proxy(this.cycle, this))
  }

  Carousel.VERSION  = '3.2.0'

  Carousel.TRANSITION_DURATION = 600

  Carousel.DEFAULTS = {
    interval: 5000,
    pause: 'hover',
    wrap: true
  }

  Carousel.prototype.keydown = function (e) {
    switch (e.which) {
      case 37: this.prev(); break
      case 39: this.next(); break
      default: return
    }

    e.preventDefault()
  }

  Carousel.prototype.cycle = function (e) {
    e || (this.paused = false)

    this.interval && clearInterval(this.interval)

    this.options.interval
      && !this.paused
      && (this.interval = setInterval($.proxy(this.next, this), this.options.interval))

    return this
  }

  Carousel.prototype.getItemIndex = function (item) {
    this.$items = item.parent().children('.item')
    return this.$items.index(item || this.$active)
  }

  Carousel.prototype.getItemForDirection = function (direction, active) {
    var delta = direction == 'prev' ? -1 : 1
    var activeIndex = this.getItemIndex(active)
    var itemIndex = (activeIndex + delta) % this.$items.length
    return this.$items.eq(itemIndex)
  }

  Carousel.prototype.to = function (pos) {
    var that        = this
    var activeIndex = this.getItemIndex(this.$active = this.$element.find('.item.active'))

    if (pos > (this.$items.length - 1) || pos < 0) return

    if (this.sliding)       return this.$element.one('slid.bs.carousel', function () { that.to(pos) }) // yes, "slid"
    if (activeIndex == pos) return this.pause().cycle()

    return this.slide(pos > activeIndex ? 'next' : 'prev', this.$items.eq(pos))
  }

  Carousel.prototype.pause = function (e) {
    e || (this.paused = true)

    if (this.$element.find('.next, .prev').length && $.support.transition) {
      this.$element.trigger($.support.transition.end)
      this.cycle(true)
    }

    this.interval = clearInterval(this.interval)

    return this
  }

  Carousel.prototype.next = function () {
    if (this.sliding) return
    return this.slide('next')
  }

  Carousel.prototype.prev = function () {
    if (this.sliding) return
    return this.slide('prev')
  }

  Carousel.prototype.slide = function (type, next) {
    var $active   = this.$element.find('.item.active')
    var $next     = next || this.getItemForDirection(type, $active)
    var isCycling = this.interval
    var direction = type == 'next' ? 'left' : 'right'
    var fallback  = type == 'next' ? 'first' : 'last'
    var that      = this

    if (!$next.length) {
      if (!this.options.wrap) return
      $next = this.$element.find('.item')[fallback]()
    }

    if ($next.hasClass('active')) return (this.sliding = false)

    var relatedTarget = $next[0]
    var slideEvent = $.Event('slide.bs.carousel', {
      relatedTarget: relatedTarget,
      direction: direction
    })
    this.$element.trigger(slideEvent)
    if (slideEvent.isDefaultPrevented()) return

    this.sliding = true

    isCycling && this.pause()

    if (this.$indicators.length) {
      this.$indicators.find('.active').removeClass('active')
      var $nextIndicator = $(this.$indicators.children()[this.getItemIndex($next)])
      $nextIndicator && $nextIndicator.addClass('active')
    }

    var slidEvent = $.Event('slid.bs.carousel', { relatedTarget: relatedTarget, direction: direction }) // yes, "slid"
    if ($.support.transition && this.$element.hasClass('slide')) {
      $next.addClass(type)
      $next[0].offsetWidth // force reflow
      $active.addClass(direction)
      $next.addClass(direction)
      $active
        .one('bsTransitionEnd', function () {
          $next.removeClass([type, direction].join(' ')).addClass('active')
          $active.removeClass(['active', direction].join(' '))
          that.sliding = false
          setTimeout(function () {
            that.$element.trigger(slidEvent)
          }, 0)
        })
        .emulateTransitionEnd(Carousel.TRANSITION_DURATION)
    } else {
      $active.removeClass('active')
      $next.addClass('active')
      this.sliding = false
      this.$element.trigger(slidEvent)
    }

    isCycling && this.cycle()

    return this
  }


  // CAROUSEL PLUGIN DEFINITION
  // ==========================

  function Plugin(option) {
    return this.each(function () {
      var $this   = $(this)
      var data    = $this.data('bs.carousel')
      var options = $.extend({}, Carousel.DEFAULTS, $this.data(), typeof option == 'object' && option)
      var action  = typeof option == 'string' ? option : options.slide

      if (!data) $this.data('bs.carousel', (data = new Carousel(this, options)))
      if (typeof option == 'number') data.to(option)
      else if (action) data[action]()
      else if (options.interval) data.pause().cycle()
    })
  }

  var old = $.fn.carousel

  $.fn.carousel             = Plugin
  $.fn.carousel.Constructor = Carousel


  // CAROUSEL NO CONFLICT
  // ====================

  $.fn.carousel.noConflict = function () {
    $.fn.carousel = old
    return this
  }


  // CAROUSEL DATA-API
  // =================

  $(document).on('click.bs.carousel.data-api', '[data-slide], [data-slide-to]', function (e) {
    var href
    var $this   = $(this)
    var $target = $($this.attr('data-target') || (href = $this.attr('href')) && href.replace(/.*(?=#[^\s]+$)/, '')) // strip for ie7
    if (!$target.hasClass('carousel')) return
    var options = $.extend({}, $target.data(), $this.data())
    var slideIndex = $this.attr('data-slide-to')
    if (slideIndex) options.interval = false

    Plugin.call($target, options)

    if (slideIndex) {
      $target.data('bs.carousel').to(slideIndex)
    }

    e.preventDefault()
  })

  $(window).on('load', function () {
    $('[data-ride="carousel"]').each(function () {
      var $carousel = $(this)
      Plugin.call($carousel, $carousel.data())
    })
  })

}(jQuery);

///#source 1 1 /Themes/Default/js/plugins/slick/slick.js
/*
     _ _      _       _
 ___| (_) ___| | __  (_)___
/ __| | |/ __| |/ /  | / __|
\__ \ | | (__|   < _ | \__ \
|___/_|_|\___|_|\_(_)/ |___/
                   |__/

 Version: 1.5.0
  Author: Ken Wheeler
 Website: http://kenwheeler.github.io
    Docs: http://kenwheeler.github.io/slick
    Repo: http://github.com/kenwheeler/slick
  Issues: http://github.com/kenwheeler/slick/issues

 */
/* global window, document, define, jQuery, setInterval, clearInterval */
(function(factory) {
    'use strict';
    if (typeof define === 'function' && define.amd) {
        define(['jquery'], factory);
    } else if (typeof exports !== 'undefined') {
        module.exports = factory(require('jquery'));
    } else {
        factory(jQuery);
    }

}(function($) {
    'use strict';
    var Slick = window.Slick || {};

    Slick = (function() {

        var instanceUid = 0;

        function Slick(element, settings) {

            var _ = this,
                dataSettings, responsiveSettings, breakpoint;

            _.defaults = {
                accessibility: true,
                adaptiveHeight: false,
                appendArrows: $(element),
                appendDots: $(element),
                arrows: true,
                asNavFor: null,
                prevArrow: '<button type="button" data-role="none" class="slick-prev" aria-label="previous">Previous</button>',
                nextArrow: '<button type="button" data-role="none" class="slick-next" aria-label="next">Next</button>',
                autoplay: false,
                autoplaySpeed: 3000,
                centerMode: false,
                centerPadding: '50px',
                cssEase: 'ease',
                customPaging: function(slider, i) {
                    return '<button type="button" data-role="none">' + (i + 1) + '</button>';
                },
                dots: false,
                dotsClass: 'slick-dots',
                draggable: true,
                easing: 'linear',
                edgeFriction: 0.35,
                fade: false,
                focusOnSelect: false,
                infinite: true,
                initialSlide: 0,
                lazyLoad: 'ondemand',
                mobileFirst: false,
                pauseOnHover: true,
                pauseOnDotsHover: false,
                respondTo: 'window',
                responsive: null,
                rows: 1,
                rtl: false,
                slide: '',
                slidesPerRow: 1,
                slidesToShow: 1,
                slidesToScroll: 1,
                speed: 500,
                swipe: true,
                swipeToSlide: false,
                touchMove: true,
                touchThreshold: 5,
                useCSS: true,
                variableWidth: false,
                vertical: false,
                verticalSwiping: false,
                waitForAnimate: true
            };

            _.initials = {
                animating: false,
                dragging: false,
                autoPlayTimer: null,
                currentDirection: 0,
                currentLeft: null,
                currentSlide: 0,
                direction: 1,
                $dots: null,
                listWidth: null,
                listHeight: null,
                loadIndex: 0,
                $nextArrow: null,
                $prevArrow: null,
                slideCount: null,
                slideWidth: null,
                $slideTrack: null,
                $slides: null,
                sliding: false,
                slideOffset: 0,
                swipeLeft: null,
                $list: null,
                touchObject: {},
                transformsEnabled: false
            };

            $.extend(_, _.initials);

            _.activeBreakpoint = null;
            _.animType = null;
            _.animProp = null;
            _.breakpoints = [];
            _.breakpointSettings = [];
            _.cssTransitions = false;
            _.hidden = 'hidden';
            _.paused = false;
            _.positionProp = null;
            _.respondTo = null;
            _.rowCount = 1;
            _.shouldClick = true;
            _.$slider = $(element);
            _.$slidesCache = null;
            _.transformType = null;
            _.transitionType = null;
            _.visibilityChange = 'visibilitychange';
            _.windowWidth = 0;
            _.windowTimer = null;

            dataSettings = $(element).data('slick') || {};

            _.options = $.extend({}, _.defaults, dataSettings, settings);

            _.currentSlide = _.options.initialSlide;

            _.originalSettings = _.options;
            responsiveSettings = _.options.responsive || null;

            if (responsiveSettings && responsiveSettings.length > -1) {
                _.respondTo = _.options.respondTo || 'window';
                for (breakpoint in responsiveSettings) {
                    if (responsiveSettings.hasOwnProperty(breakpoint)) {
                        _.breakpoints.push(responsiveSettings[
                            breakpoint].breakpoint);
                        _.breakpointSettings[responsiveSettings[
                                breakpoint].breakpoint] =
                            responsiveSettings[breakpoint].settings;
                    }
                }
                _.breakpoints.sort(function(a, b) {
                    if (_.options.mobileFirst === true) {
                        return a - b;
                    } else {
                        return b - a;
                    }
                });
            }

            if (typeof document.mozHidden !== 'undefined') {
                _.hidden = 'mozHidden';
                _.visibilityChange = 'mozvisibilitychange';
            } else if (typeof document.webkitHidden !== 'undefined') {
                _.hidden = 'webkitHidden';
                _.visibilityChange = 'webkitvisibilitychange';
            }

            _.autoPlay = $.proxy(_.autoPlay, _);
            _.autoPlayClear = $.proxy(_.autoPlayClear, _);
            _.changeSlide = $.proxy(_.changeSlide, _);
            _.clickHandler = $.proxy(_.clickHandler, _);
            _.selectHandler = $.proxy(_.selectHandler, _);
            _.setPosition = $.proxy(_.setPosition, _);
            _.swipeHandler = $.proxy(_.swipeHandler, _);
            _.dragHandler = $.proxy(_.dragHandler, _);
            _.keyHandler = $.proxy(_.keyHandler, _);
            _.autoPlayIterator = $.proxy(_.autoPlayIterator, _);

            _.instanceUid = instanceUid++;

            // A simple way to check for HTML strings
            // Strict HTML recognition (must start with <)
            // Extracted from jQuery v1.11 source
            _.htmlExpr = /^(?:\s*(<[\w\W]+>)[^>]*)$/;

            _.init();

            _.checkResponsive(true);

        }

        return Slick;

    }());

    Slick.prototype.addSlide = Slick.prototype.slickAdd = function(markup, index, addBefore) {

        var _ = this;

        if (typeof(index) === 'boolean') {
            addBefore = index;
            index = null;
        } else if (index < 0 || (index >= _.slideCount)) {
            return false;
        }

        _.unload();

        if (typeof(index) === 'number') {
            if (index === 0 && _.$slides.length === 0) {
                $(markup).appendTo(_.$slideTrack);
            } else if (addBefore) {
                $(markup).insertBefore(_.$slides.eq(index));
            } else {
                $(markup).insertAfter(_.$slides.eq(index));
            }
        } else {
            if (addBefore === true) {
                $(markup).prependTo(_.$slideTrack);
            } else {
                $(markup).appendTo(_.$slideTrack);
            }
        }

        _.$slides = _.$slideTrack.children(this.options.slide);

        _.$slideTrack.children(this.options.slide).detach();

        _.$slideTrack.append(_.$slides);

        _.$slides.each(function(index, element) {
            $(element).attr('data-slick-index', index);
        });

        _.$slidesCache = _.$slides;

        _.reinit();

    };

    Slick.prototype.animateHeight = function() {
        var _ = this;
        if (_.options.slidesToShow === 1 && _.options.adaptiveHeight === true && _.options.vertical === false) {
            var targetHeight = _.$slides.eq(_.currentSlide).outerHeight(true);
            _.$list.animate({
                height: targetHeight
            }, _.options.speed);
        }
    };

    Slick.prototype.animateSlide = function(targetLeft, callback) {

        var animProps = {},
            _ = this;

        _.animateHeight();

        if (_.options.rtl === true && _.options.vertical === false) {
            targetLeft = -targetLeft;
        }
        if (_.transformsEnabled === false) {
            if (_.options.vertical === false) {
                _.$slideTrack.animate({
                    left: targetLeft
                }, _.options.speed, _.options.easing, callback);
            } else {
                _.$slideTrack.animate({
                    top: targetLeft
                }, _.options.speed, _.options.easing, callback);
            }

        } else {

            if (_.cssTransitions === false) {
                if (_.options.rtl === true) {
                    _.currentLeft = -(_.currentLeft);
                }
                $({
                    animStart: _.currentLeft
                }).animate({
                    animStart: targetLeft
                }, {
                    duration: _.options.speed,
                    easing: _.options.easing,
                    step: function(now) {
                        now = Math.ceil(now);
                        if (_.options.vertical === false) {
                            animProps[_.animType] = 'translate(' +
                                now + 'px, 0px)';
                            _.$slideTrack.css(animProps);
                        } else {
                            animProps[_.animType] = 'translate(0px,' +
                                now + 'px)';
                            _.$slideTrack.css(animProps);
                        }
                    },
                    complete: function() {
                        if (callback) {
                            callback.call();
                        }
                    }
                });

            } else {

                _.applyTransition();
                targetLeft = Math.ceil(targetLeft);

                if (_.options.vertical === false) {
                    animProps[_.animType] = 'translate3d(' + targetLeft + 'px, 0px, 0px)';
                } else {
                    animProps[_.animType] = 'translate3d(0px,' + targetLeft + 'px, 0px)';
                }
                _.$slideTrack.css(animProps);

                if (callback) {
                    setTimeout(function() {

                        _.disableTransition();

                        callback.call();
                    }, _.options.speed);
                }

            }

        }

    };

    Slick.prototype.asNavFor = function(index) {
        var _ = this,
            asNavFor = _.options.asNavFor !== null ? $(_.options.asNavFor).slick('getSlick') : null;
        if (asNavFor !== null) asNavFor.slideHandler(index, true);
    };

    Slick.prototype.applyTransition = function(slide) {

        var _ = this,
            transition = {};

        if (_.options.fade === false) {
            transition[_.transitionType] = _.transformType + ' ' + _.options.speed + 'ms ' + _.options.cssEase;
        } else {
            transition[_.transitionType] = 'opacity ' + _.options.speed + 'ms ' + _.options.cssEase;
        }

        if (_.options.fade === false) {
            _.$slideTrack.css(transition);
        } else {
            _.$slides.eq(slide).css(transition);
        }

    };

    Slick.prototype.autoPlay = function() {

        var _ = this;

        if (_.autoPlayTimer) {
            clearInterval(_.autoPlayTimer);
        }

        if (_.slideCount > _.options.slidesToShow && _.paused !== true) {
            _.autoPlayTimer = setInterval(_.autoPlayIterator,
                _.options.autoplaySpeed);
        }

    };

    Slick.prototype.autoPlayClear = function() {

        var _ = this;
        if (_.autoPlayTimer) {
            clearInterval(_.autoPlayTimer);
        }

    };

    Slick.prototype.autoPlayIterator = function() {

        var _ = this;

        if (_.options.infinite === false) {

            if (_.direction === 1) {

                if ((_.currentSlide + 1) === _.slideCount -
                    1) {
                    _.direction = 0;
                }

                _.slideHandler(_.currentSlide + _.options.slidesToScroll);

            } else {

                if ((_.currentSlide - 1 === 0)) {

                    _.direction = 1;

                }

                _.slideHandler(_.currentSlide - _.options.slidesToScroll);

            }

        } else {

            _.slideHandler(_.currentSlide + _.options.slidesToScroll);

        }

    };

    Slick.prototype.buildArrows = function() {

        var _ = this;

        if (_.options.arrows === true && _.slideCount > _.options.slidesToShow) {

            _.$prevArrow = $(_.options.prevArrow);
            _.$nextArrow = $(_.options.nextArrow);

            if (_.htmlExpr.test(_.options.prevArrow)) {
                _.$prevArrow.appendTo(_.options.appendArrows);
            }

            if (_.htmlExpr.test(_.options.nextArrow)) {
                _.$nextArrow.appendTo(_.options.appendArrows);
            }

            if (_.options.infinite !== true) {
                _.$prevArrow.addClass('slick-disabled');
            }

        }

    };

    Slick.prototype.buildDots = function() {

        var _ = this,
            i, dotString;

        if (_.options.dots === true && _.slideCount > _.options.slidesToShow) {

            dotString = '<ul class="' + _.options.dotsClass + '">';

            for (i = 0; i <= _.getDotCount(); i += 1) {
                dotString += '<li>' + _.options.customPaging.call(this, _, i) + '</li>';
            }

            dotString += '</ul>';

            _.$dots = $(dotString).appendTo(
                _.options.appendDots);

            _.$dots.find('li').first().addClass('slick-active').attr('aria-hidden', 'false');

        }

    };

    Slick.prototype.buildOut = function() {

        var _ = this;

        _.$slides = _.$slider.children(
            ':not(.slick-cloned)').addClass(
            'slick-slide');
        _.slideCount = _.$slides.length;

        _.$slides.each(function(index, element) {
            $(element).attr('data-slick-index', index);
        });

        _.$slidesCache = _.$slides;

        _.$slider.addClass('slick-slider');

        _.$slideTrack = (_.slideCount === 0) ?
            $('<div class="slick-track"/>').appendTo(_.$slider) :
            _.$slides.wrapAll('<div class="slick-track"/>').parent();

        _.$list = _.$slideTrack.wrap(
            '<div aria-live="polite" class="slick-list"/>').parent();
        _.$slideTrack.css('opacity', 0);

        if (_.options.centerMode === true || _.options.swipeToSlide === true) {
            _.options.slidesToScroll = 1;
        }

        $('img[data-lazy]', _.$slider).not('[src]').addClass('slick-loading');

        _.setupInfinite();

        _.buildArrows();

        _.buildDots();

        _.updateDots();

        if (_.options.accessibility === true) {
            _.$list.prop('tabIndex', 0);
        }

        _.setSlideClasses(typeof this.currentSlide === 'number' ? this.currentSlide : 0);

        if (_.options.draggable === true) {
            _.$list.addClass('draggable');
        }

    };

    Slick.prototype.buildRows = function() {

        var _ = this, a, b, c, newSlides, numOfSlides, originalSlides,slidesPerSection;

        newSlides = document.createDocumentFragment();
        originalSlides = _.$slider.children();

        if(_.options.rows > 1) {
            slidesPerSection = _.options.slidesPerRow * _.options.rows;
            numOfSlides = Math.ceil(
                originalSlides.length / slidesPerSection
            );

            for(a = 0; a < numOfSlides; a++){
                var slide = document.createElement('div');
                for(b = 0; b < _.options.rows; b++) {
                    var row = document.createElement('div');
                    for(c = 0; c < _.options.slidesPerRow; c++) {
                        var target = (a * slidesPerSection + ((b * _.options.slidesPerRow) + c));
                        if (originalSlides.get(target)) {
                            row.appendChild(originalSlides.get(target));
                        }
                    }
                    slide.appendChild(row);
                }
                newSlides.appendChild(slide);
            };
            _.$slider.html(newSlides);
            _.$slider.children().children().children()
                .width((100 / _.options.slidesPerRow) + "%")
                .css({'display': 'inline-block'});
        };

    };

    Slick.prototype.checkResponsive = function(initial) {

        var _ = this,
            breakpoint, targetBreakpoint, respondToWidth;
        var sliderWidth = _.$slider.width();
        var windowWidth = window.innerWidth || $(window).width();
        if (_.respondTo === 'window') {
            respondToWidth = windowWidth;
        } else if (_.respondTo === 'slider') {
            respondToWidth = sliderWidth;
        } else if (_.respondTo === 'min') {
            respondToWidth = Math.min(windowWidth, sliderWidth);
        }

        if (_.originalSettings.responsive && _.originalSettings
            .responsive.length > -1 && _.originalSettings.responsive !== null) {

            targetBreakpoint = null;

            for (breakpoint in _.breakpoints) {
                if (_.breakpoints.hasOwnProperty(breakpoint)) {
                    if (_.originalSettings.mobileFirst === false) {
                        if (respondToWidth < _.breakpoints[breakpoint]) {
                            targetBreakpoint = _.breakpoints[breakpoint];
                        }
                    } else {
                        if (respondToWidth > _.breakpoints[breakpoint]) {
                            targetBreakpoint = _.breakpoints[breakpoint];
                        }
                    }
                }
            }

            if (targetBreakpoint !== null) {
                if (_.activeBreakpoint !== null) {
                    if (targetBreakpoint !== _.activeBreakpoint) {
                        _.activeBreakpoint =
                            targetBreakpoint;
                        if (_.breakpointSettings[targetBreakpoint] === 'unslick') {
                            _.unslick();
                        } else {
                            _.options = $.extend({}, _.originalSettings,
                                _.breakpointSettings[
                                    targetBreakpoint]);
                            if (initial === true)
                                _.currentSlide = _.options.initialSlide;
                            _.refresh();
                        }
                    }
                } else {
                    _.activeBreakpoint = targetBreakpoint;
                    if (_.breakpointSettings[targetBreakpoint] === 'unslick') {
                        _.unslick();
                    } else {
                        _.options = $.extend({}, _.originalSettings,
                            _.breakpointSettings[
                                targetBreakpoint]);
                        if (initial === true)
                            _.currentSlide = _.options.initialSlide;
                        _.refresh();
                    }
                }
            } else {
                if (_.activeBreakpoint !== null) {
                    _.activeBreakpoint = null;
                    _.options = _.originalSettings;
                    if (initial === true)
                        _.currentSlide = _.options.initialSlide;
                    _.refresh();
                }
            }

        }

    };

    Slick.prototype.changeSlide = function(event, dontAnimate) {

        var _ = this,
            $target = $(event.target),
            indexOffset, slideOffset, unevenOffset;

        // If target is a link, prevent default action.
        $target.is('a') && event.preventDefault();

        unevenOffset = (_.slideCount % _.options.slidesToScroll !== 0);
        indexOffset = unevenOffset ? 0 : (_.slideCount - _.currentSlide) % _.options.slidesToScroll;

        switch (event.data.message) {

            case 'previous':
                slideOffset = indexOffset === 0 ? _.options.slidesToScroll : _.options.slidesToShow - indexOffset;
                if (_.slideCount > _.options.slidesToShow) {
                    _.slideHandler(_.currentSlide - slideOffset, false, dontAnimate);
                }
                break;

            case 'next':
                slideOffset = indexOffset === 0 ? _.options.slidesToScroll : indexOffset;
                if (_.slideCount > _.options.slidesToShow) {
                    _.slideHandler(_.currentSlide + slideOffset, false, dontAnimate);
                }
                break;

            case 'index':
                var index = event.data.index === 0 ? 0 :
                    event.data.index || $(event.target).parent().index() * _.options.slidesToScroll;

                _.slideHandler(_.checkNavigable(index), false, dontAnimate);
                break;

            default:
                return;
        }

    };

    Slick.prototype.checkNavigable = function(index) {

        var _ = this,
            navigables, prevNavigable;

        navigables = _.getNavigableIndexes();
        prevNavigable = 0;
        if (index > navigables[navigables.length - 1]) {
            index = navigables[navigables.length - 1];
        } else {
            for (var n in navigables) {
                if (index < navigables[n]) {
                    index = prevNavigable;
                    break;
                }
                prevNavigable = navigables[n];
            }
        }

        return index;
    };

    Slick.prototype.cleanUpEvents = function() {

        var _ = this;

        if (_.options.dots === true && _.slideCount > _.options.slidesToShow) {
            $('li', _.$dots).off('click.slick', _.changeSlide);
        }

        if (_.options.dots === true && _.options.pauseOnDotsHover === true && _.options.autoplay === true) {
            $('li', _.$dots)
                .off('mouseenter.slick', _.setPaused.bind(_, true))
                .off('mouseleave.slick', _.setPaused.bind(_, false));
        }

        if (_.options.arrows === true && _.slideCount > _.options.slidesToShow) {
            _.$prevArrow && _.$prevArrow.off('click.slick', _.changeSlide);
            _.$nextArrow && _.$nextArrow.off('click.slick', _.changeSlide);
        }

        _.$list.off('touchstart.slick mousedown.slick', _.swipeHandler);
        _.$list.off('touchmove.slick mousemove.slick', _.swipeHandler);
        _.$list.off('touchend.slick mouseup.slick', _.swipeHandler);
        _.$list.off('touchcancel.slick mouseleave.slick', _.swipeHandler);

        _.$list.off('click.slick', _.clickHandler);

        $(document).off(_.visibilityChange, _.visibility);

        _.$list.off('mouseenter.slick', _.setPaused.bind(_, true));
        _.$list.off('mouseleave.slick', _.setPaused.bind(_, false));

        if (_.options.accessibility === true) {
            _.$list.off('keydown.slick', _.keyHandler);
        }

        if (_.options.focusOnSelect === true) {
            $(_.$slideTrack).children().off('click.slick', _.selectHandler);
        }

        $(window).off('orientationchange.slick.slick-' + _.instanceUid, _.orientationChange);

        $(window).off('resize.slick.slick-' + _.instanceUid, _.resize);

        $('[draggable!=true]', _.$slideTrack).off('dragstart', _.preventDefault);

        $(window).off('load.slick.slick-' + _.instanceUid, _.setPosition);
        $(document).off('ready.slick.slick-' + _.instanceUid, _.setPosition);
    };

    Slick.prototype.cleanUpRows = function() {

        var _ = this, originalSlides;

        if(_.options.rows > 1) {
            originalSlides = _.$slides.children().children();
            originalSlides.removeAttr('style');
            _.$slider.html(originalSlides);
        }

    };

    Slick.prototype.clickHandler = function(event) {

        var _ = this;

        if (_.shouldClick === false) {
            event.stopImmediatePropagation();
            event.stopPropagation();
            event.preventDefault();
        }

    };

    Slick.prototype.destroy = function() {

        var _ = this;

        _.autoPlayClear();

        _.touchObject = {};

        _.cleanUpEvents();

        $('.slick-cloned', _.$slider).remove();

        if (_.$dots) {
            _.$dots.remove();
        }
        if (_.$prevArrow && (typeof _.options.prevArrow !== 'object')) {
            _.$prevArrow.remove();
        }
        if (_.$nextArrow && (typeof _.options.nextArrow !== 'object')) {
            _.$nextArrow.remove();
        }

        if (_.$slides) {
            _.$slides.removeClass('slick-slide slick-active slick-center slick-visible')
                .attr('aria-hidden', 'true')
                .removeAttr('data-slick-index')
                .css({
                    position: '',
                    left: '',
                    top: '',
                    zIndex: '',
                    opacity: '',
                    width: ''
                });

            _.$slider.html(_.$slides);
        }

        _.cleanUpRows();

        _.$slider.removeClass('slick-slider');
        _.$slider.removeClass('slick-initialized');

    };

    Slick.prototype.disableTransition = function(slide) {

        var _ = this,
            transition = {};

        transition[_.transitionType] = '';

        if (_.options.fade === false) {
            _.$slideTrack.css(transition);
        } else {
            _.$slides.eq(slide).css(transition);
        }

    };

    Slick.prototype.fadeSlide = function(slideIndex, callback) {

        var _ = this;

        if (_.cssTransitions === false) {

            _.$slides.eq(slideIndex).css({
                zIndex: 1000
            });

            _.$slides.eq(slideIndex).animate({
                opacity: 1
            }, _.options.speed, _.options.easing, callback);

        } else {

            _.applyTransition(slideIndex);

            _.$slides.eq(slideIndex).css({
                opacity: 1,
                zIndex: 1000
            });

            if (callback) {
                setTimeout(function() {

                    _.disableTransition(slideIndex);

                    callback.call();
                }, _.options.speed);
            }

        }

    };

    Slick.prototype.filterSlides = Slick.prototype.slickFilter = function(filter) {

        var _ = this;

        if (filter !== null) {

            _.unload();

            _.$slideTrack.children(this.options.slide).detach();

            _.$slidesCache.filter(filter).appendTo(_.$slideTrack);

            _.reinit();

        }

    };

    Slick.prototype.getCurrent = Slick.prototype.slickCurrentSlide = function() {

        var _ = this;
        return _.currentSlide;

    };

    Slick.prototype.getDotCount = function() {

        var _ = this;

        var breakPoint = 0;
        var counter = 0;
        var pagerQty = 0;

        if (_.options.infinite === true) {
            pagerQty = Math.ceil(_.slideCount / _.options.slidesToScroll);
        } else if (_.options.centerMode === true) {
            pagerQty = _.slideCount;
        } else {
            while (breakPoint < _.slideCount) {
                ++pagerQty;
                breakPoint = counter + _.options.slidesToShow;
                counter += _.options.slidesToScroll <= _.options.slidesToShow ? _.options.slidesToScroll : _.options.slidesToShow;
            }
        }

        return pagerQty - 1;

    };

    Slick.prototype.getLeft = function(slideIndex) {

        var _ = this,
            targetLeft,
            verticalHeight,
            verticalOffset = 0,
            targetSlide;

        _.slideOffset = 0;
        verticalHeight = _.$slides.first().outerHeight();

        if (_.options.infinite === true) {
            if (_.slideCount > _.options.slidesToShow) {
                _.slideOffset = (_.slideWidth * _.options.slidesToShow) * -1;
                verticalOffset = (verticalHeight * _.options.slidesToShow) * -1;
            }
            if (_.slideCount % _.options.slidesToScroll !== 0) {
                if (slideIndex + _.options.slidesToScroll > _.slideCount && _.slideCount > _.options.slidesToShow) {
                    if (slideIndex > _.slideCount) {
                        _.slideOffset = ((_.options.slidesToShow - (slideIndex - _.slideCount)) * _.slideWidth) * -1;
                        verticalOffset = ((_.options.slidesToShow - (slideIndex - _.slideCount)) * verticalHeight) * -1;
                    } else {
                        _.slideOffset = ((_.slideCount % _.options.slidesToScroll) * _.slideWidth) * -1;
                        verticalOffset = ((_.slideCount % _.options.slidesToScroll) * verticalHeight) * -1;
                    }
                }
            }
        } else {
            if (slideIndex + _.options.slidesToShow > _.slideCount) {
                _.slideOffset = ((slideIndex + _.options.slidesToShow) - _.slideCount) * _.slideWidth;
                verticalOffset = ((slideIndex + _.options.slidesToShow) - _.slideCount) * verticalHeight;
            }
        }

        if (_.slideCount <= _.options.slidesToShow) {
            _.slideOffset = 0;
            verticalOffset = 0;
        }

        if (_.options.centerMode === true && _.options.infinite === true) {
            _.slideOffset += _.slideWidth * Math.floor(_.options.slidesToShow / 2) - _.slideWidth;
        } else if (_.options.centerMode === true) {
            _.slideOffset = 0;
            _.slideOffset += _.slideWidth * Math.floor(_.options.slidesToShow / 2);
        }

        if (_.options.vertical === false) {
            targetLeft = ((slideIndex * _.slideWidth) * -1) + _.slideOffset;
        } else {
            targetLeft = ((slideIndex * verticalHeight) * -1) + verticalOffset;
        }

        if (_.options.variableWidth === true) {

            if (_.slideCount <= _.options.slidesToShow || _.options.infinite === false) {
                targetSlide = _.$slideTrack.children('.slick-slide').eq(slideIndex);
            } else {
                targetSlide = _.$slideTrack.children('.slick-slide').eq(slideIndex + _.options.slidesToShow);
            }

            targetLeft = targetSlide[0] ? targetSlide[0].offsetLeft * -1 : 0;

            if (_.options.centerMode === true) {
                if (_.options.infinite === false) {
                    targetSlide = _.$slideTrack.children('.slick-slide').eq(slideIndex);
                } else {
                    targetSlide = _.$slideTrack.children('.slick-slide').eq(slideIndex + _.options.slidesToShow + 1);
                }
                targetLeft = targetSlide[0] ? targetSlide[0].offsetLeft * -1 : 0;
                targetLeft += (_.$list.width() - targetSlide.outerWidth()) / 2;
            }
        }

        return targetLeft;

    };

    Slick.prototype.getOption = Slick.prototype.slickGetOption = function(option) {

        var _ = this;

        return _.options[option];

    };

    Slick.prototype.getNavigableIndexes = function() {

        var _ = this,
            breakPoint = 0,
            counter = 0,
            indexes = [],
            max;

        if (_.options.infinite === false) {
            max = _.slideCount - _.options.slidesToShow + 1;
            if (_.options.centerMode === true) max = _.slideCount;
        } else {
            breakPoint = _.options.slidesToScroll * -1;
            counter = _.options.slidesToScroll * -1;
            max = _.slideCount * 2;
        }

        while (breakPoint < max) {
            indexes.push(breakPoint);
            breakPoint = counter + _.options.slidesToScroll;
            counter += _.options.slidesToScroll <= _.options.slidesToShow ? _.options.slidesToScroll : _.options.slidesToShow;
        }

        return indexes;

    };

    Slick.prototype.getSlick = function() {

        return this;

    };

    Slick.prototype.getSlideCount = function() {

        var _ = this,
            slidesTraversed, swipedSlide, centerOffset;

        centerOffset = _.options.centerMode === true ? _.slideWidth * Math.floor(_.options.slidesToShow / 2) : 0;

        if (_.options.swipeToSlide === true) {
            _.$slideTrack.find('.slick-slide').each(function(index, slide) {
                if (slide.offsetLeft - centerOffset + ($(slide).outerWidth() / 2) > (_.swipeLeft * -1)) {
                    swipedSlide = slide;
                    return false;
                }
            });

            slidesTraversed = Math.abs($(swipedSlide).attr('data-slick-index') - _.currentSlide) || 1;

            return slidesTraversed;

        } else {
            return _.options.slidesToScroll;
        }

    };

    Slick.prototype.goTo = Slick.prototype.slickGoTo = function(slide, dontAnimate) {

        var _ = this;

        _.changeSlide({
            data: {
                message: 'index',
                index: parseInt(slide)
            }
        }, dontAnimate);

    };

    Slick.prototype.init = function() {

        var _ = this;

        if (!$(_.$slider).hasClass('slick-initialized')) {

            $(_.$slider).addClass('slick-initialized');
            _.buildRows();
            _.buildOut();
            _.setProps();
            _.startLoad();
            _.loadSlider();
            _.initializeEvents();
            _.updateArrows();
            _.updateDots();
        }

        _.$slider.trigger('init', [_]);

    };

    Slick.prototype.initArrowEvents = function() {

        var _ = this;

        if (_.options.arrows === true && _.slideCount > _.options.slidesToShow) {
            _.$prevArrow.on('click.slick', {
                message: 'previous'
            }, _.changeSlide);
            _.$nextArrow.on('click.slick', {
                message: 'next'
            }, _.changeSlide);
        }

    };

    Slick.prototype.initDotEvents = function() {

        var _ = this;

        if (_.options.dots === true && _.slideCount > _.options.slidesToShow) {
            $('li', _.$dots).on('click.slick', {
                message: 'index'
            }, _.changeSlide);
        }

        if (_.options.dots === true && _.options.pauseOnDotsHover === true && _.options.autoplay === true) {
            $('li', _.$dots)
                .on('mouseenter.slick', _.setPaused.bind(_, true))
                .on('mouseleave.slick', _.setPaused.bind(_, false));
        }

    };

    Slick.prototype.initializeEvents = function() {

        var _ = this;

        _.initArrowEvents();

        _.initDotEvents();

        _.$list.on('touchstart.slick mousedown.slick', {
            action: 'start'
        }, _.swipeHandler);
        _.$list.on('touchmove.slick mousemove.slick', {
            action: 'move'
        }, _.swipeHandler);
        _.$list.on('touchend.slick mouseup.slick', {
            action: 'end'
        }, _.swipeHandler);
        _.$list.on('touchcancel.slick mouseleave.slick', {
            action: 'end'
        }, _.swipeHandler);

        _.$list.on('click.slick', _.clickHandler);

        $(document).on(_.visibilityChange, _.visibility.bind(_));

        _.$list.on('mouseenter.slick', _.setPaused.bind(_, true));
        _.$list.on('mouseleave.slick', _.setPaused.bind(_, false));

        if (_.options.accessibility === true) {
            _.$list.on('keydown.slick', _.keyHandler);
        }

        if (_.options.focusOnSelect === true) {
            $(_.$slideTrack).children().on('click.slick', _.selectHandler);
        }

        $(window).on('orientationchange.slick.slick-' + _.instanceUid, _.orientationChange.bind(_));

        $(window).on('resize.slick.slick-' + _.instanceUid, _.resize.bind(_));

        $('[draggable!=true]', _.$slideTrack).on('dragstart', _.preventDefault);

        $(window).on('load.slick.slick-' + _.instanceUid, _.setPosition);
        $(document).on('ready.slick.slick-' + _.instanceUid, _.setPosition);

    };

    Slick.prototype.initUI = function() {

        var _ = this;

        if (_.options.arrows === true && _.slideCount > _.options.slidesToShow) {

            _.$prevArrow.show();
            _.$nextArrow.show();

        }

        if (_.options.dots === true && _.slideCount > _.options.slidesToShow) {

            _.$dots.show();

        }

        if (_.options.autoplay === true) {

            _.autoPlay();

        }

    };

    Slick.prototype.keyHandler = function(event) {

        var _ = this;

        if (event.keyCode === 37 && _.options.accessibility === true) {
            _.changeSlide({
                data: {
                    message: 'previous'
                }
            });
        } else if (event.keyCode === 39 && _.options.accessibility === true) {
            _.changeSlide({
                data: {
                    message: 'next'
                }
            });
        }

    };

    Slick.prototype.lazyLoad = function() {

        var _ = this,
            loadRange, cloneRange, rangeStart, rangeEnd;

        function loadImages(imagesScope) {
            $('img[data-lazy]', imagesScope).each(function() {
                var image = $(this),
                    imageSource = $(this).attr('data-lazy'),
                    imageToLoad = document.createElement('img');

                imageToLoad.onload = function() {
                    image.animate({
                        opacity: 1
                    }, 200);
                };
                imageToLoad.src = imageSource;

                image
                    .css({
                        opacity: 0
                    })
                    .attr('src', imageSource)
                    .removeAttr('data-lazy')
                    .removeClass('slick-loading');
            });
        }

        if (_.options.centerMode === true) {
            if (_.options.infinite === true) {
                rangeStart = _.currentSlide + (_.options.slidesToShow / 2 + 1);
                rangeEnd = rangeStart + _.options.slidesToShow + 2;
            } else {
                rangeStart = Math.max(0, _.currentSlide - (_.options.slidesToShow / 2 + 1));
                rangeEnd = 2 + (_.options.slidesToShow / 2 + 1) + _.currentSlide;
            }
        } else {
            rangeStart = _.options.infinite ? _.options.slidesToShow + _.currentSlide : _.currentSlide;
            rangeEnd = rangeStart + _.options.slidesToShow;
            if (_.options.fade === true) {
                if (rangeStart > 0) rangeStart--;
                if (rangeEnd <= _.slideCount) rangeEnd++;
            }
        }

        loadRange = _.$slider.find('.slick-slide').slice(rangeStart, rangeEnd);
        loadImages(loadRange);

        if (_.slideCount <= _.options.slidesToShow) {
            cloneRange = _.$slider.find('.slick-slide');
            loadImages(cloneRange);
        } else
        if (_.currentSlide >= _.slideCount - _.options.slidesToShow) {
            cloneRange = _.$slider.find('.slick-cloned').slice(0, _.options.slidesToShow);
            loadImages(cloneRange);
        } else if (_.currentSlide === 0) {
            cloneRange = _.$slider.find('.slick-cloned').slice(_.options.slidesToShow * -1);
            loadImages(cloneRange);
        }

    };

    Slick.prototype.loadSlider = function() {

        var _ = this;

        _.setPosition();

        _.$slideTrack.css({
            opacity: 1
        });

        _.$slider.removeClass('slick-loading');

        _.initUI();

        if (_.options.lazyLoad === 'progressive') {
            _.progressiveLazyLoad();
        }

    };

    Slick.prototype.next = Slick.prototype.slickNext = function() {

        var _ = this;

        _.changeSlide({
            data: {
                message: 'next'
            }
        });

    };

    Slick.prototype.orientationChange = function() {

        var _ = this;

        _.checkResponsive();
        _.setPosition();

    };

    Slick.prototype.pause = Slick.prototype.slickPause = function() {

        var _ = this;

        _.autoPlayClear();
        _.paused = true;

    };

    Slick.prototype.play = Slick.prototype.slickPlay = function() {

        var _ = this;

        _.paused = false;
        _.autoPlay();

    };

    Slick.prototype.postSlide = function(index) {

        var _ = this;

        _.$slider.trigger('afterChange', [_, index]);

        _.animating = false;

        _.setPosition();

        _.swipeLeft = null;

        if (_.options.autoplay === true && _.paused === false) {
            _.autoPlay();
        }

    };

    Slick.prototype.prev = Slick.prototype.slickPrev = function() {

        var _ = this;

        _.changeSlide({
            data: {
                message: 'previous'
            }
        });

    };

    Slick.prototype.preventDefault = function(e) {
        e.preventDefault();
    };

    Slick.prototype.progressiveLazyLoad = function() {

        var _ = this,
            imgCount, targetImage;

        imgCount = $('img[data-lazy]', _.$slider).length;

        if (imgCount > 0) {
            targetImage = $('img[data-lazy]', _.$slider).first();
            targetImage.attr('src', targetImage.attr('data-lazy')).removeClass('slick-loading').load(function() {
                    targetImage.removeAttr('data-lazy');
                    _.progressiveLazyLoad();

                    if (_.options.adaptiveHeight === true) {
                        _.setPosition();
                    }
                })
                .error(function() {
                    targetImage.removeAttr('data-lazy');
                    _.progressiveLazyLoad();
                });
        }

    };

    Slick.prototype.refresh = function() {

        var _ = this,
            currentSlide = _.currentSlide;

        _.destroy();

        $.extend(_, _.initials);

        _.init();

        _.changeSlide({
            data: {
                message: 'index',
                index: currentSlide
            }
        }, false);

    };

    Slick.prototype.reinit = function() {

        var _ = this;

        _.$slides = _.$slideTrack.children(_.options.slide).addClass(
            'slick-slide');

        _.slideCount = _.$slides.length;

        if (_.currentSlide >= _.slideCount && _.currentSlide !== 0) {
            _.currentSlide = _.currentSlide - _.options.slidesToScroll;
        }

        if (_.slideCount <= _.options.slidesToShow) {
            _.currentSlide = 0;
        }

        _.setProps();

        _.setupInfinite();

        _.buildArrows();

        _.updateArrows();

        _.initArrowEvents();

        _.buildDots();

        _.updateDots();

        _.initDotEvents();

        if (_.options.focusOnSelect === true) {
            $(_.$slideTrack).children().on('click.slick', _.selectHandler);
        }

        _.setSlideClasses(0);

        _.setPosition();

        _.$slider.trigger('reInit', [_]);

    };

    Slick.prototype.resize = function() {

        var _ = this;

        if ($(window).width() !== _.windowWidth) {
            clearTimeout(_.windowDelay);
            _.windowDelay = window.setTimeout(function() {
                _.windowWidth = $(window).width();
                _.checkResponsive();
                _.setPosition();
            }, 50);
        }
    };

    Slick.prototype.removeSlide = Slick.prototype.slickRemove = function(index, removeBefore, removeAll) {

        var _ = this;

        if (typeof(index) === 'boolean') {
            removeBefore = index;
            index = removeBefore === true ? 0 : _.slideCount - 1;
        } else {
            index = removeBefore === true ? --index : index;
        }

        if (_.slideCount < 1 || index < 0 || index > _.slideCount - 1) {
            return false;
        }

        _.unload();

        if (removeAll === true) {
            _.$slideTrack.children().remove();
        } else {
            _.$slideTrack.children(this.options.slide).eq(index).remove();
        }

        _.$slides = _.$slideTrack.children(this.options.slide);

        _.$slideTrack.children(this.options.slide).detach();

        _.$slideTrack.append(_.$slides);

        _.$slidesCache = _.$slides;

        _.reinit();

    };

    Slick.prototype.setCSS = function(position) {

        var _ = this,
            positionProps = {},
            x, y;

        if (_.options.rtl === true) {
            position = -position;
        }
        x = _.positionProp == 'left' ? Math.ceil(position) + 'px' : '0px';
        y = _.positionProp == 'top' ? Math.ceil(position) + 'px' : '0px';

        positionProps[_.positionProp] = position;

        if (_.transformsEnabled === false) {
            _.$slideTrack.css(positionProps);
        } else {
            positionProps = {};
            if (_.cssTransitions === false) {
                positionProps[_.animType] = 'translate(' + x + ', ' + y + ')';
                _.$slideTrack.css(positionProps);
            } else {
                positionProps[_.animType] = 'translate3d(' + x + ', ' + y + ', 0px)';
                _.$slideTrack.css(positionProps);
            }
        }

    };

    Slick.prototype.setDimensions = function() {

        var _ = this;

        if (_.options.vertical === false) {
            if (_.options.centerMode === true) {
                _.$list.css({
                    padding: ('0px ' + _.options.centerPadding)
                });
            }
        } else {
            _.$list.height(_.$slides.first().outerHeight(true) * _.options.slidesToShow);
            if (_.options.centerMode === true) {
                _.$list.css({
                    padding: (_.options.centerPadding + ' 0px')
                });
            }
        }

        _.listWidth = _.$list.width();
        _.listHeight = _.$list.height();


        if (_.options.vertical === false && _.options.variableWidth === false) {
            _.slideWidth = Math.ceil(_.listWidth / _.options.slidesToShow);
            _.$slideTrack.width(Math.ceil((_.slideWidth * _.$slideTrack.children('.slick-slide').length)));

        } else if (_.options.variableWidth === true) {
            _.$slideTrack.width(5000 * _.slideCount);
        } else {
            _.slideWidth = Math.ceil(_.listWidth);
            _.$slideTrack.height(Math.ceil((_.$slides.first().outerHeight(true) * _.$slideTrack.children('.slick-slide').length)));
        }

        var offset = _.$slides.first().outerWidth(true) - _.$slides.first().width();
        if (_.options.variableWidth === false) _.$slideTrack.children('.slick-slide').width(_.slideWidth - offset);

    };

    Slick.prototype.setFade = function() {

        var _ = this,
            targetLeft;

        _.$slides.each(function(index, element) {
            targetLeft = (_.slideWidth * index) * -1;
            if (_.options.rtl === true) {
                $(element).css({
                    position: 'relative',
                    right: targetLeft,
                    top: 0,
                    zIndex: 800,
                    opacity: 0
                });
            } else {
                $(element).css({
                    position: 'relative',
                    left: targetLeft,
                    top: 0,
                    zIndex: 800,
                    opacity: 0
                });
            }
        });

        _.$slides.eq(_.currentSlide).css({
            zIndex: 900,
            opacity: 1
        });

    };

    Slick.prototype.setHeight = function() {

        var _ = this;

        if (_.options.slidesToShow === 1 && _.options.adaptiveHeight === true && _.options.vertical === false) {
            var targetHeight = _.$slides.eq(_.currentSlide).outerHeight(true);
            _.$list.css('height', targetHeight);
        }

    };

    Slick.prototype.setOption = Slick.prototype.slickSetOption = function(option, value, refresh) {

        var _ = this;
        _.options[option] = value;

        if (refresh === true) {
            _.unload();
            _.reinit();
        }

    };

    Slick.prototype.setPosition = function() {

        var _ = this;

        _.setDimensions();

        _.setHeight();

        if (_.options.fade === false) {
            _.setCSS(_.getLeft(_.currentSlide));
        } else {
            _.setFade();
        }

        _.$slider.trigger('setPosition', [_]);

    };

    Slick.prototype.setProps = function() {

        var _ = this,
            bodyStyle = document.body.style;

        _.positionProp = _.options.vertical === true ? 'top' : 'left';

        if (_.positionProp === 'top') {
            _.$slider.addClass('slick-vertical');
        } else {
            _.$slider.removeClass('slick-vertical');
        }

        if (bodyStyle.WebkitTransition !== undefined ||
            bodyStyle.MozTransition !== undefined ||
            bodyStyle.msTransition !== undefined) {
            if (_.options.useCSS === true) {
                _.cssTransitions = true;
            }
        }

        if (bodyStyle.OTransform !== undefined) {
            _.animType = 'OTransform';
            _.transformType = '-o-transform';
            _.transitionType = 'OTransition';
            if (bodyStyle.perspectiveProperty === undefined && bodyStyle.webkitPerspective === undefined) _.animType = false;
        }
        if (bodyStyle.MozTransform !== undefined) {
            _.animType = 'MozTransform';
            _.transformType = '-moz-transform';
            _.transitionType = 'MozTransition';
            if (bodyStyle.perspectiveProperty === undefined && bodyStyle.MozPerspective === undefined) _.animType = false;
        }
        if (bodyStyle.webkitTransform !== undefined) {
            _.animType = 'webkitTransform';
            _.transformType = '-webkit-transform';
            _.transitionType = 'webkitTransition';
            if (bodyStyle.perspectiveProperty === undefined && bodyStyle.webkitPerspective === undefined) _.animType = false;
        }
        if (bodyStyle.msTransform !== undefined) {
            _.animType = 'msTransform';
            _.transformType = '-ms-transform';
            _.transitionType = 'msTransition';
            if (bodyStyle.msTransform === undefined) _.animType = false;
        }
        if (bodyStyle.transform !== undefined && _.animType !== false) {
            _.animType = 'transform';
            _.transformType = 'transform';
            _.transitionType = 'transition';
        }
        _.transformsEnabled = (_.animType !== null && _.animType !== false);

    };


    Slick.prototype.setSlideClasses = function(index) {

        var _ = this,
            centerOffset, allSlides, indexOffset, remainder;

        _.$slider.find('.slick-slide').removeClass('slick-active').attr('aria-hidden', 'true').removeClass('slick-center');
        allSlides = _.$slider.find('.slick-slide');

        if (_.options.centerMode === true) {

            centerOffset = Math.floor(_.options.slidesToShow / 2);

            if (_.options.infinite === true) {

                if (index >= centerOffset && index <= (_.slideCount - 1) - centerOffset) {
                    _.$slides.slice(index - centerOffset, index + centerOffset + 1).addClass('slick-active').attr('aria-hidden', 'false');
                } else {
                    indexOffset = _.options.slidesToShow + index;
                    allSlides.slice(indexOffset - centerOffset + 1, indexOffset + centerOffset + 2).addClass('slick-active').attr('aria-hidden', 'false');
                }

                if (index === 0) {
                    allSlides.eq(allSlides.length - 1 - _.options.slidesToShow).addClass('slick-center');
                } else if (index === _.slideCount - 1) {
                    allSlides.eq(_.options.slidesToShow).addClass('slick-center');
                }

            }

            _.$slides.eq(index).addClass('slick-center');

        } else {

            if (index >= 0 && index <= (_.slideCount - _.options.slidesToShow)) {
                _.$slides.slice(index, index + _.options.slidesToShow).addClass('slick-active').attr('aria-hidden', 'false');
            } else if (allSlides.length <= _.options.slidesToShow) {
                allSlides.addClass('slick-active').attr('aria-hidden', 'false');
            } else {
                remainder = _.slideCount % _.options.slidesToShow;
                indexOffset = _.options.infinite === true ? _.options.slidesToShow + index : index;
                if (_.options.slidesToShow == _.options.slidesToScroll && (_.slideCount - index) < _.options.slidesToShow) {
                    allSlides.slice(indexOffset - (_.options.slidesToShow - remainder), indexOffset + remainder).addClass('slick-active').attr('aria-hidden', 'false');
                } else {
                    allSlides.slice(indexOffset, indexOffset + _.options.slidesToShow).addClass('slick-active').attr('aria-hidden', 'false');
                }
            }

        }

        if (_.options.lazyLoad === 'ondemand') {
            _.lazyLoad();
        }

    };

    Slick.prototype.setupInfinite = function() {

        var _ = this,
            i, slideIndex, infiniteCount;

        if (_.options.fade === true) {
            _.options.centerMode = false;
        }

        if (_.options.infinite === true && _.options.fade === false) {

            slideIndex = null;

            if (_.slideCount > _.options.slidesToShow) {

                if (_.options.centerMode === true) {
                    infiniteCount = _.options.slidesToShow + 1;
                } else {
                    infiniteCount = _.options.slidesToShow;
                }

                for (i = _.slideCount; i > (_.slideCount -
                        infiniteCount); i -= 1) {
                    slideIndex = i - 1;
                    $(_.$slides[slideIndex]).clone(true).attr('id', '')
                        .attr('data-slick-index', slideIndex - _.slideCount)
                        .prependTo(_.$slideTrack).addClass('slick-cloned');
                }
                for (i = 0; i < infiniteCount; i += 1) {
                    slideIndex = i;
                    $(_.$slides[slideIndex]).clone(true).attr('id', '')
                        .attr('data-slick-index', slideIndex + _.slideCount)
                        .appendTo(_.$slideTrack).addClass('slick-cloned');
                }
                _.$slideTrack.find('.slick-cloned').find('[id]').each(function() {
                    $(this).attr('id', '');
                });

            }

        }

    };

    Slick.prototype.setPaused = function(paused) {

        var _ = this;

        if (_.options.autoplay === true && _.options.pauseOnHover === true) {
            _.paused = paused;
            _.autoPlayClear();
        }
    };

    Slick.prototype.selectHandler = function(event) {

        var _ = this;

        var targetElement = $(event.target).is('.slick-slide') ?
            $(event.target) :
            $(event.target).parents('.slick-slide');

        var index = parseInt(targetElement.attr('data-slick-index'));

        if (!index) index = 0;

        if (_.slideCount <= _.options.slidesToShow) {
            _.$slider.find('.slick-slide').removeClass('slick-active').attr('aria-hidden', 'true');
            _.$slides.eq(index).addClass('slick-active').attr("aria-hidden", "false");
            if (_.options.centerMode === true) {
                _.$slider.find('.slick-slide').removeClass('slick-center');
                _.$slides.eq(index).addClass('slick-center');
            }
            _.asNavFor(index);
            return;
        }
        _.slideHandler(index);

    };

    Slick.prototype.slideHandler = function(index, sync, dontAnimate) {

        var targetSlide, animSlide, oldSlide, slideLeft, targetLeft = null,
            _ = this;

        sync = sync || false;

        if (_.animating === true && _.options.waitForAnimate === true) {
            return;
        }

        if (_.options.fade === true && _.currentSlide === index) {
            return;
        }

        if (_.slideCount <= _.options.slidesToShow) {
            return;
        }

        if (sync === false) {
            _.asNavFor(index);
        }

        targetSlide = index;
        targetLeft = _.getLeft(targetSlide);
        slideLeft = _.getLeft(_.currentSlide);

        _.currentLeft = _.swipeLeft === null ? slideLeft : _.swipeLeft;

        if (_.options.infinite === false && _.options.centerMode === false && (index < 0 || index > _.getDotCount() * _.options.slidesToScroll)) {
            if (_.options.fade === false) {
                targetSlide = _.currentSlide;
                if (dontAnimate !== true) {
                    _.animateSlide(slideLeft, function() {
                        _.postSlide(targetSlide);
                    });
                } else {
                    _.postSlide(targetSlide);
                }
            }
            return;
        } else if (_.options.infinite === false && _.options.centerMode === true && (index < 0 || index > (_.slideCount - _.options.slidesToScroll))) {
            if (_.options.fade === false) {
                targetSlide = _.currentSlide;
                if (dontAnimate !== true) {
                    _.animateSlide(slideLeft, function() {
                        _.postSlide(targetSlide);
                    });
                } else {
                    _.postSlide(targetSlide);
                }
            }
            return;
        }

        if (_.options.autoplay === true) {
            clearInterval(_.autoPlayTimer);
        }

        if (targetSlide < 0) {
            if (_.slideCount % _.options.slidesToScroll !== 0) {
                animSlide = _.slideCount - (_.slideCount % _.options.slidesToScroll);
            } else {
                animSlide = _.slideCount + targetSlide;
            }
        } else if (targetSlide >= _.slideCount) {
            if (_.slideCount % _.options.slidesToScroll !== 0) {
                animSlide = 0;
            } else {
                animSlide = targetSlide - _.slideCount;
            }
        } else {
            animSlide = targetSlide;
        }

        _.animating = true;

        _.$slider.trigger("beforeChange", [_, _.currentSlide, animSlide]);

        oldSlide = _.currentSlide;
        _.currentSlide = animSlide;

        _.setSlideClasses(_.currentSlide);

        _.updateDots();
        _.updateArrows();

        if (_.options.fade === true) {
            if (dontAnimate !== true) {
                _.fadeSlide(animSlide, function() {
                    _.postSlide(animSlide);
                });
            } else {
                _.postSlide(animSlide);
            }
            _.animateHeight();
            return;
        }

        if (dontAnimate !== true) {
            _.animateSlide(targetLeft, function() {
                _.postSlide(animSlide);
            });
        } else {
            _.postSlide(animSlide);
        }

    };

    Slick.prototype.startLoad = function() {

        var _ = this;

        if (_.options.arrows === true && _.slideCount > _.options.slidesToShow) {

            _.$prevArrow.hide();
            _.$nextArrow.hide();

        }

        if (_.options.dots === true && _.slideCount > _.options.slidesToShow) {

            _.$dots.hide();

        }

        _.$slider.addClass('slick-loading');

    };

    Slick.prototype.swipeDirection = function() {

        var xDist, yDist, r, swipeAngle, _ = this;

        xDist = _.touchObject.startX - _.touchObject.curX;
        yDist = _.touchObject.startY - _.touchObject.curY;
        r = Math.atan2(yDist, xDist);

        swipeAngle = Math.round(r * 180 / Math.PI);
        if (swipeAngle < 0) {
            swipeAngle = 360 - Math.abs(swipeAngle);
        }

        if ((swipeAngle <= 45) && (swipeAngle >= 0)) {
            return (_.options.rtl === false ? 'left' : 'right');
        }
        if ((swipeAngle <= 360) && (swipeAngle >= 315)) {
            return (_.options.rtl === false ? 'left' : 'right');
        }
        if ((swipeAngle >= 135) && (swipeAngle <= 225)) {
            return (_.options.rtl === false ? 'right' : 'left');
        }
        if (_.options.verticalSwiping === true) {
            if ((swipeAngle >= 35) && (swipeAngle <= 135)) {
                return 'left';
            } else {
                return 'right';
            }
        }

        return 'vertical';

    };

    Slick.prototype.swipeEnd = function(event) {

        var _ = this,
            slideCount;

        _.dragging = false;

        _.shouldClick = (_.touchObject.swipeLength > 10) ? false : true;

        if (_.touchObject.curX === undefined) {
            return false;
        }

        if (_.touchObject.edgeHit === true) {
            _.$slider.trigger("edge", [_, _.swipeDirection()]);
        }

        if (_.touchObject.swipeLength >= _.touchObject.minSwipe) {

            switch (_.swipeDirection()) {
                case 'left':
                    slideCount = _.options.swipeToSlide ? _.checkNavigable(_.currentSlide + _.getSlideCount()) : _.currentSlide + _.getSlideCount();
                    _.slideHandler(slideCount);
                    _.currentDirection = 0;
                    _.touchObject = {};
                    _.$slider.trigger("swipe", [_, "left"]);
                    break;

                case 'right':
                    slideCount = _.options.swipeToSlide ? _.checkNavigable(_.currentSlide - _.getSlideCount()) : _.currentSlide - _.getSlideCount();
                    _.slideHandler(slideCount);
                    _.currentDirection = 1;
                    _.touchObject = {};
                    _.$slider.trigger("swipe", [_, "right"]);
                    break;
            }
        } else {
            if (_.touchObject.startX !== _.touchObject.curX) {
                _.slideHandler(_.currentSlide);
                _.touchObject = {};
            }
        }

    };

    Slick.prototype.swipeHandler = function(event) {

        var _ = this;

        if ((_.options.swipe === false) || ('ontouchend' in document && _.options.swipe === false)) {
            return;
        } else if (_.options.draggable === false && event.type.indexOf('mouse') !== -1) {
            return;
        }

        _.touchObject.fingerCount = event.originalEvent && event.originalEvent.touches !== undefined ?
            event.originalEvent.touches.length : 1;

        _.touchObject.minSwipe = _.listWidth / _.options
            .touchThreshold;

        if (_.options.verticalSwiping === true) {
            _.touchObject.minSwipe = _.listHeight / _.options
                .touchThreshold;
        }

        switch (event.data.action) {

            case 'start':
                _.swipeStart(event);
                break;

            case 'move':
                _.swipeMove(event);
                break;

            case 'end':
                _.swipeEnd(event);
                break;

        }

    };

    Slick.prototype.swipeMove = function(event) {

        var _ = this,
            edgeWasHit = false,
            curLeft, swipeDirection, swipeLength, positionOffset, touches;

        touches = event.originalEvent !== undefined ? event.originalEvent.touches : null;

        if (!_.dragging || touches && touches.length !== 1) {
            return false;
        }

        curLeft = _.getLeft(_.currentSlide);

        _.touchObject.curX = touches !== undefined ? touches[0].pageX : event.clientX;
        _.touchObject.curY = touches !== undefined ? touches[0].pageY : event.clientY;

        _.touchObject.swipeLength = Math.round(Math.sqrt(
            Math.pow(_.touchObject.curX - _.touchObject.startX, 2)));

        if (_.options.verticalSwiping === true) {
            _.touchObject.swipeLength = Math.round(Math.sqrt(
                Math.pow(_.touchObject.curY - _.touchObject.startY, 2)));
        }

        swipeDirection = _.swipeDirection();

        if (swipeDirection === 'vertical') {
            return;
        }

        if (event.originalEvent !== undefined && _.touchObject.swipeLength > 4) {
            event.preventDefault();
        }

        positionOffset = (_.options.rtl === false ? 1 : -1) * (_.touchObject.curX > _.touchObject.startX ? 1 : -1);
        if (_.options.verticalSwiping === true) {
            positionOffset = _.touchObject.curY > _.touchObject.startY ? 1 : -1;
        }


        swipeLength = _.touchObject.swipeLength;

        _.touchObject.edgeHit = false;

        if (_.options.infinite === false) {
            if ((_.currentSlide === 0 && swipeDirection === "right") || (_.currentSlide >= _.getDotCount() && swipeDirection === "left")) {
                swipeLength = _.touchObject.swipeLength * _.options.edgeFriction;
                _.touchObject.edgeHit = true;
            }
        }

        if (_.options.vertical === false) {
            _.swipeLeft = curLeft + swipeLength * positionOffset;
        } else {
            _.swipeLeft = curLeft + (swipeLength * (_.$list.height() / _.listWidth)) * positionOffset;
        }
        if (_.options.verticalSwiping === true) {
            _.swipeLeft = curLeft + swipeLength * positionOffset;
        }

        if (_.options.fade === true || _.options.touchMove === false) {
            return false;
        }

        if (_.animating === true) {
            _.swipeLeft = null;
            return false;
        }

        _.setCSS(_.swipeLeft);

    };

    Slick.prototype.swipeStart = function(event) {

        var _ = this,
            touches;

        if (_.touchObject.fingerCount !== 1 || _.slideCount <= _.options.slidesToShow) {
            _.touchObject = {};
            return false;
        }

        if (event.originalEvent !== undefined && event.originalEvent.touches !== undefined) {
            touches = event.originalEvent.touches[0];
        }

        _.touchObject.startX = _.touchObject.curX = touches !== undefined ? touches.pageX : event.clientX;
        _.touchObject.startY = _.touchObject.curY = touches !== undefined ? touches.pageY : event.clientY;

        _.dragging = true;

    };

    Slick.prototype.unfilterSlides = Slick.prototype.slickUnfilter = function() {

        var _ = this;

        if (_.$slidesCache !== null) {

            _.unload();

            _.$slideTrack.children(this.options.slide).detach();

            _.$slidesCache.appendTo(_.$slideTrack);

            _.reinit();

        }

    };

    Slick.prototype.unload = function() {

        var _ = this;

        $('.slick-cloned', _.$slider).remove();
        if (_.$dots) {
            _.$dots.remove();
        }
        if (_.$prevArrow && (typeof _.options.prevArrow !== 'object')) {
            _.$prevArrow.remove();
        }
        if (_.$nextArrow && (typeof _.options.nextArrow !== 'object')) {
            _.$nextArrow.remove();
        }
        _.$slides.removeClass('slick-slide slick-active slick-visible').attr("aria-hidden", "true").css('width', '');

    };

    Slick.prototype.unslick = function() {

        var _ = this;
        _.destroy();

    };

    Slick.prototype.updateArrows = function() {

        var _ = this,
            centerOffset;

        centerOffset = Math.floor(_.options.slidesToShow / 2);

        if (_.options.arrows === true && _.options.infinite !==
            true && _.slideCount > _.options.slidesToShow) {
            _.$prevArrow.removeClass('slick-disabled');
            _.$nextArrow.removeClass('slick-disabled');
            if (_.currentSlide === 0) {
                _.$prevArrow.addClass('slick-disabled');
                _.$nextArrow.removeClass('slick-disabled');
            } else if (_.currentSlide >= _.slideCount - _.options.slidesToShow && _.options.centerMode === false) {
                _.$nextArrow.addClass('slick-disabled');
                _.$prevArrow.removeClass('slick-disabled');
            } else if (_.currentSlide >= _.slideCount - 1 && _.options.centerMode === true) {
                _.$nextArrow.addClass('slick-disabled');
                _.$prevArrow.removeClass('slick-disabled');
            }
        }

    };

    Slick.prototype.updateDots = function() {

        var _ = this;

        if (_.$dots !== null) {

            _.$dots.find('li').removeClass('slick-active').attr("aria-hidden", "true");
            _.$dots.find('li').eq(Math.floor(_.currentSlide / _.options.slidesToScroll)).addClass('slick-active').attr("aria-hidden", "false");

        }

    };

    Slick.prototype.visibility = function() {
            
        var _ = this;

        if (document[_.hidden]) {
            _.paused = true;
            _.autoPlayClear();
        } else {
            if (_.options.autoplay === true) {
                _.paused = false;
                _.autoPlay();
            }
        }

    };

    $.fn.slick = function() {
        var _ = this,
            opt = arguments[0],
            args = Array.prototype.slice.call(arguments, 1),
            l = _.length,
            i = 0,
            ret;
        for (i; i < l; i++) {
            if (typeof opt == 'object' || typeof opt == 'undefined')
                _[i].slick = new Slick(_[i], opt);
            else
                ret = _[i].slick[opt].apply(_[i].slick, args);
            if (typeof ret != 'undefined') return ret;
        }
        return _;
    };

}));

///#source 1 1 /Themes/Default/js/plugins/bootbox.js
/**
 * bootbox.js [v4.2.0]
 *
 * http://bootboxjs.com/license.txt
 */

// @see https://github.com/makeusabrew/bootbox/issues/180
// @see https://github.com/makeusabrew/bootbox/issues/186
(function (root, factory) {

  "use strict";
  if (typeof define === "function" && define.amd) {
    // AMD. Register as an anonymous module.
    define(["jquery"], factory);
  } else if (typeof exports === "object") {
    // Node. Does not work with strict CommonJS, but
    // only CommonJS-like environments that support module.exports,
    // like Node.
    module.exports = factory(require("jquery"));
  } else {
    // Browser globals (root is window)
    root.bootbox = factory(root.jQuery);
  }

}(this, function init($, undefined) {

  "use strict";

  // the base DOM structure needed to create a modal
  var templates = {
    dialog:
      "<div class='bootbox modal' tabindex='-1' role='dialog'>" +
        "<div class='modal-dialog'>" +
          "<div class='modal-content'>" +
            "<div class='modal-body'><div class='bootbox-body'></div></div>" +
          "</div>" +
        "</div>" +
      "</div>",
    header:
      "<div class='modal-header'>" +
        "<h4 class='modal-title'></h4>" +
      "</div>",
    footer:
      "<div class='modal-footer'></div>",
    closeButton:
      "<button type='button' class='bootbox-close-button close' data-dismiss='modal' aria-hidden='true'>&times;</button>",
    form:
      "<form class='bootbox-form'></form>",
    inputs: {
      text:
        "<input class='bootbox-input bootbox-input-text form-control' autocomplete=off type=text />",
      textarea:
        "<textarea class='bootbox-input bootbox-input-textarea form-control'></textarea>",
      email:
        "<input class='bootbox-input bootbox-input-email form-control' autocomplete='off' type='email' />",
      select:
        "<select class='bootbox-input bootbox-input-select form-control'></select>",
      checkbox:
        "<div class='checkbox'><label><input class='bootbox-input bootbox-input-checkbox' type='checkbox' /></label></div>",
      date:
        "<input class='bootbox-input bootbox-input-date form-control' autocomplete=off type='date' />",
      time:
        "<input class='bootbox-input bootbox-input-time form-control' autocomplete=off type='time' />",
      number:
        "<input class='bootbox-input bootbox-input-number form-control' autocomplete=off type='number' />",
      password:
        "<input class='bootbox-input bootbox-input-password form-control' autocomplete='off' type='password' />"
    }
  };

  var defaults = {
    // default language
    locale: "en",
    // show backdrop or not
    backdrop: true,
    // animate the modal in/out
    animate: true,
    // additional class string applied to the top level dialog
    className: null,
    // whether or not to include a close button
    closeButton: true,
    // show the dialog immediately by default
    show: true,
    // dialog container
    container: "body"
  };

  // our public object; augmented after our private API
  var exports = {};

  /**
   * @private
   */
  function _t(key) {
    var locale = locales[defaults.locale];
    return locale ? locale[key] : locales.en[key];
  }

  function processCallback(e, dialog, callback) {
    e.stopPropagation();
    e.preventDefault();

    // by default we assume a callback will get rid of the dialog,
    // although it is given the opportunity to override this

    // so, if the callback can be invoked and it *explicitly returns false*
    // then we'll set a flag to keep the dialog active...
    var preserveDialog = $.isFunction(callback) && callback(e) === false;

    // ... otherwise we'll bin it
    if (!preserveDialog) {
      dialog.modal("hide");
    }
  }

  function getKeyLength(obj) {
    // @TODO defer to Object.keys(x).length if available?
    var k, t = 0;
    for (k in obj) {
      t ++;
    }
    return t;
  }

  function each(collection, iterator) {
    var index = 0;
    $.each(collection, function(key, value) {
      iterator(key, value, index++);
    });
  }

  function sanitize(options) {
    var buttons;
    var total;

    if (typeof options !== "object") {
      throw new Error("Please supply an object of options");
    }

    if (!options.message) {
      throw new Error("Please specify a message");
    }

    // make sure any supplied options take precedence over defaults
    options = $.extend({}, defaults, options);

    if (!options.buttons) {
      options.buttons = {};
    }

    // we only support Bootstrap's "static" and false backdrop args
    // supporting true would mean you could dismiss the dialog without
    // explicitly interacting with it
    options.backdrop = options.backdrop ? "static" : false;

    buttons = options.buttons;

    total = getKeyLength(buttons);

    each(buttons, function(key, button, index) {

      if ($.isFunction(button)) {
        // short form, assume value is our callback. Since button
        // isn't an object it isn't a reference either so re-assign it
        button = buttons[key] = {
          callback: button
        };
      }

      // before any further checks make sure by now button is the correct type
      if ($.type(button) !== "object") {
        throw new Error("button with key " + key + " must be an object");
      }

      if (!button.label) {
        // the lack of an explicit label means we'll assume the key is good enough
        button.label = key;
      }

      if (!button.className) {
        if (total <= 2 && index === total-1) {
          // always add a primary to the main option in a two-button dialog
          button.className = "btn-primary";
        } else {
          button.className = "btn-default";
        }
      }
    });

    return options;
  }

  /**
   * map a flexible set of arguments into a single returned object
   * if args.length is already one just return it, otherwise
   * use the properties argument to map the unnamed args to
   * object properties
   * so in the latter case:
   * mapArguments(["foo", $.noop], ["message", "callback"])
   * -> { message: "foo", callback: $.noop }
   */
  function mapArguments(args, properties) {
    var argn = args.length;
    var options = {};

    if (argn < 1 || argn > 2) {
      throw new Error("Invalid argument length");
    }

    if (argn === 2 || typeof args[0] === "string") {
      options[properties[0]] = args[0];
      options[properties[1]] = args[1];
    } else {
      options = args[0];
    }

    return options;
  }

  /**
   * merge a set of default dialog options with user supplied arguments
   */
  function mergeArguments(defaults, args, properties) {
    return $.extend(
      // deep merge
      true,
      // ensure the target is an empty, unreferenced object
      {},
      // the base options object for this type of dialog (often just buttons)
      defaults,
      // args could be an object or array; if it's an array properties will
      // map it to a proper options object
      mapArguments(
        args,
        properties
      )
    );
  }

  /**
   * this entry-level method makes heavy use of composition to take a simple
   * range of inputs and return valid options suitable for passing to bootbox.dialog
   */
  function mergeDialogOptions(className, labels, properties, args) {
    //  build up a base set of dialog properties
    var baseOptions = {
      className: "bootbox-" + className,
      buttons: createLabels.apply(null, labels)
    };

    // ensure the buttons properties generated, *after* merging
    // with user args are still valid against the supplied labels
    return validateButtons(
      // merge the generated base properties with user supplied arguments
      mergeArguments(
        baseOptions,
        args,
        // if args.length > 1, properties specify how each arg maps to an object key
        properties
      ),
      labels
    );
  }

  /**
   * from a given list of arguments return a suitable object of button labels
   * all this does is normalise the given labels and translate them where possible
   * e.g. "ok", "confirm" -> { ok: "OK, cancel: "Annuleren" }
   */
  function createLabels() {
    var buttons = {};

    for (var i = 0, j = arguments.length; i < j; i++) {
      var argument = arguments[i];
      var key = argument.toLowerCase();
      var value = argument.toUpperCase();

      buttons[key] = {
        label: _t(value)
      };
    }

    return buttons;
  }

  function validateButtons(options, buttons) {
    var allowedButtons = {};
    each(buttons, function(key, value) {
      allowedButtons[value] = true;
    });

    each(options.buttons, function(key) {
      if (allowedButtons[key] === undefined) {
        throw new Error("button key " + key + " is not allowed (options are " + buttons.join("\n") + ")");
      }
    });

    return options;
  }

  exports.alert = function() {
    var options;

    options = mergeDialogOptions("alert", ["ok"], ["message", "callback"], arguments);

    if (options.callback && !$.isFunction(options.callback)) {
      throw new Error("alert requires callback property to be a function when provided");
    }

    /**
     * overrides
     */
    options.buttons.ok.callback = options.onEscape = function() {
      if ($.isFunction(options.callback)) {
        return options.callback();
      }
      return true;
    };

    return exports.dialog(options);
  };

  exports.confirm = function() {
    var options;

    options = mergeDialogOptions("confirm", ["cancel", "confirm"], ["message", "callback"], arguments);

    /**
     * overrides; undo anything the user tried to set they shouldn't have
     */
    options.buttons.cancel.callback = options.onEscape = function() {
      return options.callback(false);
    };

    options.buttons.confirm.callback = function() {
      return options.callback(true);
    };

    // confirm specific validation
    if (!$.isFunction(options.callback)) {
      throw new Error("confirm requires a callback");
    }

    return exports.dialog(options);
  };

  exports.prompt = function() {
    var options;
    var defaults;
    var dialog;
    var form;
    var input;
    var shouldShow;
    var inputOptions;

    // we have to create our form first otherwise
    // its value is undefined when gearing up our options
    // @TODO this could be solved by allowing message to
    // be a function instead...
    form = $(templates.form);

    // prompt defaults are more complex than others in that
    // users can override more defaults
    // @TODO I don't like that prompt has to do a lot of heavy
    // lifting which mergeDialogOptions can *almost* support already
    // just because of 'value' and 'inputType' - can we refactor?
    defaults = {
      className: "bootbox-prompt",
      buttons: createLabels("cancel", "confirm"),
      value: "",
      inputType: "text"
    };

    options = validateButtons(
      mergeArguments(defaults, arguments, ["title", "callback"]),
      ["cancel", "confirm"]
    );

    // capture the user's show value; we always set this to false before
    // spawning the dialog to give us a chance to attach some handlers to
    // it, but we need to make sure we respect a preference not to show it
    shouldShow = (options.show === undefined) ? true : options.show;

    // check if the browser supports the option.inputType
    var html5inputs = ["date","time","number"];
    var i = document.createElement("input");
    i.setAttribute("type", options.inputType);
    if(html5inputs[options.inputType]){
      options.inputType = i.type;
    }

    /**
     * overrides; undo anything the user tried to set they shouldn't have
     */
    options.message = form;

    options.buttons.cancel.callback = options.onEscape = function() {
      return options.callback(null);
    };

    options.buttons.confirm.callback = function() {
      var value;

      switch (options.inputType) {
        case "text":
        case "textarea":
        case "email":
        case "select":
        case "date":
        case "time":
        case "number":
        case "password":
          value = input.val();
          break;

        case "checkbox":
          var checkedItems = input.find("input:checked");

          // we assume that checkboxes are always multiple,
          // hence we default to an empty array
          value = [];

          each(checkedItems, function(_, item) {
            value.push($(item).val());
          });
          break;
      }

      return options.callback(value);
    };

    options.show = false;

    // prompt specific validation
    if (!options.title) {
      throw new Error("prompt requires a title");
    }

    if (!$.isFunction(options.callback)) {
      throw new Error("prompt requires a callback");
    }

    if (!templates.inputs[options.inputType]) {
      throw new Error("invalid prompt type");
    }

    // create the input based on the supplied type
    input = $(templates.inputs[options.inputType]);

    switch (options.inputType) {
      case "text":
      case "textarea":
      case "email":
      case "date":
      case "time":
      case "number":
      case "password":
        input.val(options.value);
        break;

      case "select":
        var groups = {};
        inputOptions = options.inputOptions || [];

        if (!inputOptions.length) {
          throw new Error("prompt with select requires options");
        }

        each(inputOptions, function(_, option) {

          // assume the element to attach to is the input...
          var elem = input;

          if (option.value === undefined || option.text === undefined) {
            throw new Error("given options in wrong format");
          }


          // ... but override that element if this option sits in a group

          if (option.group) {
            // initialise group if necessary
            if (!groups[option.group]) {
              groups[option.group] = $("<optgroup/>").attr("label", option.group);
            }

            elem = groups[option.group];
          }

          elem.append("<option value='" + option.value + "'>" + option.text + "</option>");
        });

        each(groups, function(_, group) {
          input.append(group);
        });

        // safe to set a select's value as per a normal input
        input.val(options.value);
        break;

      case "checkbox":
        var values   = $.isArray(options.value) ? options.value : [options.value];
        inputOptions = options.inputOptions || [];

        if (!inputOptions.length) {
          throw new Error("prompt with checkbox requires options");
        }

        if (!inputOptions[0].value || !inputOptions[0].text) {
          throw new Error("given options in wrong format");
        }

        // checkboxes have to nest within a containing element, so
        // they break the rules a bit and we end up re-assigning
        // our 'input' element to this container instead
        input = $("<div/>");

        each(inputOptions, function(_, option) {
          var checkbox = $(templates.inputs[options.inputType]);

          checkbox.find("input").attr("value", option.value);
          checkbox.find("label").append(option.text);

          // we've ensured values is an array so we can always iterate over it
          each(values, function(_, value) {
            if (value === option.value) {
              checkbox.find("input").prop("checked", true);
            }
          });

          input.append(checkbox);
        });
        break;
    }

    if (options.placeholder) {
      input.attr("placeholder", options.placeholder);
    }

    if(options.pattern){
      input.attr("pattern", options.pattern);
    }

    // now place it in our form
    form.append(input);

    form.on("submit", function(e) {
      e.preventDefault();
      // @TODO can we actually click *the* button object instead?
      // e.g. buttons.confirm.click() or similar
      dialog.find(".btn-primary").click();
    });

    dialog = exports.dialog(options);

    // clear the existing handler focusing the submit button...
    dialog.off("shown.bs.modal");

    // ...and replace it with one focusing our input, if possible
    dialog.on("shown.bs.modal", function() {
      input.focus();
    });

    if (shouldShow === true) {
      dialog.modal("show");
    }

    return dialog;
  };

  exports.dialog = function(options) {
    options = sanitize(options);

    var dialog = $(templates.dialog);
    var body = dialog.find(".modal-body");
    var buttons = options.buttons;
    var buttonStr = "";
    var callbacks = {
      onEscape: options.onEscape
    };

    each(buttons, function(key, button) {

      // @TODO I don't like this string appending to itself; bit dirty. Needs reworking
      // can we just build up button elements instead? slower but neater. Then button
      // can just become a template too
      buttonStr += "<button data-bb-handler='" + key + "' type='button' class='btn " + button.className + "'>" + button.label + "</button>";
      callbacks[key] = button.callback;
    });

    body.find(".bootbox-body").html(options.message);

    if (options.animate === true) {
      dialog.addClass("fade");
    }

    if (options.className) {
      dialog.addClass(options.className);
    }

    if (options.title) {
      body.before(templates.header);
    }

    if (options.closeButton) {
      var closeButton = $(templates.closeButton);

      if (options.title) {
        dialog.find(".modal-header").prepend(closeButton);
      } else {
        closeButton.css("margin-top", "-10px").prependTo(body);
      }
    }

    if (options.title) {
      dialog.find(".modal-title").html(options.title);
    }

    if (buttonStr.length) {
      body.after(templates.footer);
      dialog.find(".modal-footer").html(buttonStr);
    }


    /**
     * Bootstrap event listeners; used handle extra
     * setup & teardown required after the underlying
     * modal has performed certain actions
     */

    dialog.on("hidden.bs.modal", function(e) {
      // ensure we don't accidentally intercept hidden events triggered
      // by children of the current dialog. We shouldn't anymore now BS
      // namespaces its events; but still worth doing
      if (e.target === this) {
        dialog.remove();
      }
    });

    /*
    dialog.on("show.bs.modal", function() {
      // sadly this doesn't work; show is called *just* before
      // the backdrop is added so we'd need a setTimeout hack or
      // otherwise... leaving in as would be nice
      if (options.backdrop) {
        dialog.next(".modal-backdrop").addClass("bootbox-backdrop");
      }
    });
    */

    dialog.on("shown.bs.modal", function() {
      dialog.find(".btn-primary:first").focus();
    });

    /**
     * Bootbox event listeners; experimental and may not last
     * just an attempt to decouple some behaviours from their
     * respective triggers
     */

    dialog.on("escape.close.bb", function(e) {
      if (callbacks.onEscape) {
        processCallback(e, dialog, callbacks.onEscape);
      }
    });

    /**
     * Standard jQuery event listeners; used to handle user
     * interaction with our dialog
     */

    dialog.on("click", ".modal-footer button", function(e) {
      var callbackKey = $(this).data("bb-handler");

      processCallback(e, dialog, callbacks[callbackKey]);

    });

    dialog.on("click", ".bootbox-close-button", function(e) {
      // onEscape might be falsy but that's fine; the fact is
      // if the user has managed to click the close button we
      // have to close the dialog, callback or not
      processCallback(e, dialog, callbacks.onEscape);
    });

    dialog.on("keyup", function(e) {
      if (e.which === 27) {
        dialog.trigger("escape.close.bb");
      }
    });

    // the remainder of this method simply deals with adding our
    // dialogent to the DOM, augmenting it with Bootstrap's modal
    // functionality and then giving the resulting object back
    // to our caller

    $(options.container).append(dialog);

    dialog.modal({
      backdrop: options.backdrop,
      keyboard: false,
      show: false
    });

    if (options.show) {
      dialog.modal("show");
    }

    // @TODO should we return the raw element here or should
    // we wrap it in an object on which we can expose some neater
    // methods, e.g. var d = bootbox.alert(); d.hide(); instead
    // of d.modal("hide");

   /*
    function BBDialog(elem) {
      this.elem = elem;
    }

    BBDialog.prototype = {
      hide: function() {
        return this.elem.modal("hide");
      },
      show: function() {
        return this.elem.modal("show");
      }
    };
    */

    return dialog;

  };

  exports.setDefaults = function() {
    var values = {};

    if (arguments.length === 2) {
      // allow passing of single key/value...
      values[arguments[0]] = arguments[1];
    } else {
      // ... and as an object too
      values = arguments[0];
    }

    $.extend(defaults, values);
  };

  exports.hideAll = function() {
    $(".bootbox").modal("hide");
  };


  /**
   * standard locales. Please add more according to ISO 639-1 standard. Multiple language variants are
   * unlikely to be required. If this gets too large it can be split out into separate JS files.
   */
  var locales = {
    br : {
      OK      : "OK",
      CANCEL  : "Cancelar",
      CONFIRM : "Sim"
    },
    da : {
      OK      : "OK",
      CANCEL  : "Annuller",
      CONFIRM : "Accepter"
    },
    de : {
      OK      : "OK",
      CANCEL  : "Abbrechen",
      CONFIRM : "Akzeptieren"
    },
    en : {
      OK      : "OK",
      CANCEL  : "Cancel",
      CONFIRM : "OK"
    },
    es : {
      OK      : "OK",
      CANCEL  : "Cancelar",
      CONFIRM : "Aceptar"
    },
    fi : {
      OK      : "OK",
      CANCEL  : "Peruuta",
      CONFIRM : "OK"
    },
    fr : {
      OK      : "OK",
      CANCEL  : "Annuler",
      CONFIRM : "D'accord"
    },
    he : {
      OK      : "אישור",
      CANCEL  : "ביטול",
      CONFIRM : "אישור"
    },
    it : {
      OK      : "OK",
      CANCEL  : "Annulla",
      CONFIRM : "Conferma"
    },
    lt : {
      OK      : "Gerai",
      CANCEL  : "Atšaukti",
      CONFIRM : "Patvirtinti"
    },
    lv : {
      OK      : "Labi",
      CANCEL  : "Atcelt",
      CONFIRM : "Apstiprināt"
    },
    nl : {
      OK      : "OK",
      CANCEL  : "Annuleren",
      CONFIRM : "Accepteren"
    },
    no : {
      OK      : "OK",
      CANCEL  : "Avbryt",
      CONFIRM : "OK"
    },
    pl : {
      OK      : "OK",
      CANCEL  : "Anuluj",
      CONFIRM : "Potwierdź"
    },
    ru : {
      OK      : "OK",
      CANCEL  : "Отмена",
      CONFIRM : "Применить"
    },
    sv : {
      OK      : "OK",
      CANCEL  : "Avbryt",
      CONFIRM : "OK"
    },
    tr : {
      OK      : "Tamam",
      CANCEL  : "İptal",
      CONFIRM : "Onayla"
    },
    zh_CN : {
      OK      : "OK",
      CANCEL  : "取消",
      CONFIRM : "确认"
    },
    zh_TW : {
      OK      : "OK",
      CANCEL  : "取消",
      CONFIRM : "確認"
    }
  };

  exports.init = function(_$) {
    return init(_$ || $);
  };

  return exports;
}));

///#source 1 1 /Themes/Default/js/plugins/jquery.prettySocial.js
/**
 * jQuery prettySocial: Use custom social share buttons
 * Author: Sonny T. <hi@sonnyt.com>, sonnyt.com
 */

(function ($) {
    'use strict';

    $.fn.prettySocial = function () {
        /**
         * Supported social sites
         * @type {Object}
         */
        var _sites = {
                pinterest: {
                    url: 'http://pinterest.com/pin/create/button/?url={{url}}&media={{media}}&description={{description}}',
                    popup: {
                        width: 685,
                        height: 500
                    }
                },
                facebook: {
                    url: 'https://www.facebook.com/sharer/sharer.php?s=100&p[title]={{title}}&p[summary]={{description}}&p[url]={{url}}&p[images][0]={{media}}',
                    popup: {
                        width: 626,
                        height: 436
                    }
                },
                twitter: {
                    url: 'https://twitter.com/share?url={{url}}&via={{via}}&text={{description}}',
                    popup: {
                        width: 685,
                        height: 500
                    }
                },
                googleplus: {
                    url: 'https://plus.google.com/share?url={{url}}',
                    popup: {
                        width: 600,
                        height: 600
                    }
                },
                linkedin: {
                    url: 'https://www.linkedin.com/shareArticle?mini=true&url={{url}}&title={{title}}&summary={{description}}+&source={{via}}',
                    popup: {
                        width: 600,
                        height: 600
                    }
                }
            },

            /**
             * Pop-up window
             * This method is only used on desktop browsers
             * @param  {Object} site Selected social site
             * @param  {String} url  Fixed URL to open
             */
            _popup = function (site, url) {
                // center window
                var left = (window.innerWidth/2) - (site.popup.width/2),
                    top = (window.innerHeight/2) - (site.popup.height/2);

                return window.open(url, '', 'toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=no, resizable=no, copyhistory=no, width=' + site.popup.width + ', height=' + site.popup.height + ', top=' + top + ', left=' + left);
            },

            /**
             * Prepare link based on social sites
             * @param  {Object} site Selected social site
             * @param  {Object} link Link with variables
             * @return {String}      Polished link based on the social site template
             */
            _linkFix = function (site, link) {
                // replace template url
                var url = site.url.replace(/{{url}}/g, encodeURIComponent(link.url))
                                  .replace(/{{title}}/g, encodeURIComponent(link.title))
                                  .replace(/{{description}}/g, encodeURIComponent(link.description))
                                  .replace(/{{media}}/g, encodeURIComponent(link.media))
                                  .replace(/{{via}}/g, encodeURIComponent(link.via));

                return url;
            };

        return this.each(function() {

            // declare $(this) as variable
            var $this = $(this);

            // link type
            var type = $this.data('type'),

                // set site
                site = _sites[type] || null;

            // check if social site is selected
            if (!site) {
                $.error('Social site is not set.');
            }

            // gather link info
            var link = {
                url: $this.data('url') || '',
                title: $this.data('title') || '',
                description: $this.data('description') || '',
                media: $this.data('media') || '',
                via: $this.data('via') || ''
            };

            // prepare link
            var url = _linkFix(site, link);

            // if not, set click trigger
            if (navigator.userAgent.match(/Android|IEMobile|BlackBerry|iPhone|iPad|iPod|Opera Mini/i)) {
                $this
                .bind('touchstart', function (e) {
                    if(e.originalEvent.touches.length > 1) {
                        return;
                    }

                    $this.data('touchWithoutScroll', true);
                })
                .bind('touchmove', function () {
                    $this.data('touchWithoutScroll', false);

                    return;
                }).bind('touchend', function (e) {
                    e.preventDefault();

                    var touchWithoutScroll = $this.data('touchWithoutScroll');

                    if (e.originalEvent.touches.length > 1 || !touchWithoutScroll) {
                        return;
                    }

                    // call popup window
                    _popup(site, url);
                });
            } else {
                $this.bind('click', function (e) {
                    e.preventDefault();

                    // call popup window
                    _popup(site, url);
                });
            }
        });
    };

})(jQuery);

///#source 1 1 /Themes/Default/js/plugins/gmap3/gmap3.js
/*!
 *  GMAP3 Plugin for jQuery
 *  Version   : 6.0.0
 *  Date      : 2014-04-25
 *  Author    : DEMONTE Jean-Baptiste
 *  Contact   : jbdemonte@gmail.com
 *  Web site  : http://gmap3.net
 *  Licence   : GPL v3 : http://www.gnu.org/licenses/gpl.html
 *  
 *  Copyright (c) 2010-2014 Jean-Baptiste DEMONTE
 *  All rights reserved.
 */
;(function ($, undef) {

var defaults, gm,
  gId = 0,
  isFunction = $.isFunction,
  isArray = $.isArray;

function isObject(m) {
  return typeof m === "object";
}

function isString(m) {
  return typeof m === "string";
}

function isNumber(m) {
  return typeof m === "number";
}

function isUndefined(m) {
  return m === undef;
}

/**
 * Initialize default values
 * defaults are defined at first gmap3 call to pass the rails asset pipeline and jasmine while google library is not yet loaded
 */
function initDefaults() {
  gm = google.maps;
  if (!defaults) {
    defaults = {
      verbose: false,
      queryLimit: {
        attempt: 5,
        delay: 250, // setTimeout(..., delay + random);
        random: 250
      },
      classes: (function () {
        var r = {};
        $.each("Map Marker InfoWindow Circle Rectangle OverlayView StreetViewPanorama KmlLayer TrafficLayer BicyclingLayer GroundOverlay StyledMapType ImageMapType".split(" "), function (_, k) {
          r[k] = gm[k];
        });
        return r;
      }()),
      map: {
        mapTypeId : gm.MapTypeId.ROADMAP,
        center: [46.578498, 2.457275],
        zoom: 2
      },
      overlay: {
        pane: "floatPane",
        content: "",
        offset: {
          x: 0,
          y: 0
        }
      },
      geoloc: {
        getCurrentPosition: {
          maximumAge: 60000,
          timeout: 5000
        }
      }
    }
  }
}


/**
 * Generate a new ID if not defined
 * @param id {string} (optional)
 * @param simulate {boolean} (optional)
 * @returns {*}
 */
function globalId(id, simulate) {
  return isUndefined(id) ? "gmap3_" + (simulate ? gId + 1 : ++gId) : id;
}


/**
 * Return true if current version of Google Maps is equal or above to these in parameter
 * @param version {string} Minimal version required
 * @return {Boolean}
 */
function googleVersionMin(version) {
  var i,
    gmVersion = gm.version.split(".");
  version = version.split(".");
  for (i = 0; i < gmVersion.length; i++) {
    gmVersion[i] = parseInt(gmVersion[i], 10);
  }
  for (i = 0; i < version.length; i++) {
    version[i] = parseInt(version[i], 10);
    if (gmVersion.hasOwnProperty(i)) {
      if (gmVersion[i] < version[i]) {
        return false;
      }
    } else {
      return false;
    }
  }
  return true;
}


/**
 * attach events from a container to a sender
 * td[
 *  events => { eventName => function, }
 *  onces  => { eventName => function, }
 *  data   => mixed data
 * ]
 **/
function attachEvents($container, args, sender, id, senders) {
  var td = args.td || {},
    context = {
      id: id,
      data: td.data,
      tag: td.tag
    };
  function bind(items, handler) {
    if (items) {
      $.each(items, function (name, f) {
        var self = $container, fn = f;
        if (isArray(f)) {
          self = f[0];
          fn = f[1];
        }
        handler(sender, name, function (event) {
          fn.apply(self, [senders || sender, event, context]);
        });
      });
    }
  }
  bind(td.events, gm.event.addListener);
  bind(td.onces, gm.event.addListenerOnce);
}

/**
 * Extract keys from object
 * @param obj {object}
 * @returns {Array}
 */
function getKeys(obj) {
  var k, keys = [];
  for (k in obj) {
    if (obj.hasOwnProperty(k)) {
      keys.push(k);
    }
  }
  return keys;
}

/**
 * copy a key content
 **/
function copyKey(target, key) {
  var i,
    args = arguments;
  for (i = 2; i < args.length; i++) {
    if (key in args[i]) {
      if (args[i].hasOwnProperty(key)) {
        target[key] = args[i][key];
        return;
      }
    }
  }
}

/**
 * Build a tuple
 * @param args {object}
 * @param value {object}
 * @returns {object}
 */
function tuple(args, value) {
  var k, i,
    keys = ["data", "tag", "id", "events",  "onces"],
    td = {};

  // "copy" the common data
  if (args.td) {
    for (k in args.td) {
      if (args.td.hasOwnProperty(k)) {
        if ((k !== "options") && (k !== "values")) {
          td[k] = args.td[k];
        }
      }
    }
  }
  // "copy" some specific keys from value first else args.td
  for (i = 0; i < keys.length; i++) {
    copyKey(td, keys[i], value, args.td);
  }

  // create an extended options
  td.options = $.extend({}, args.opts || {}, value.options || {});

  return td;
}

/**
 * Log error
 */
function error() {
  if (defaults.verbose) {
    var i, err = [];
    if (window.console && (isFunction(console.error))) {
      for (i = 0; i < arguments.length; i++) {
        err.push(arguments[i]);
      }
      console.error.apply(console, err);
    } else {
      err = "";
      for (i = 0; i < arguments.length; i++) {
        err += arguments[i].toString() + " ";
      }
      alert(err);
    }
  }
}

/**
 * return true if mixed is usable as number
 **/
function numeric(mixed) {
  return (isNumber(mixed) || isString(mixed)) && mixed !== "" && !isNaN(mixed);
}

/**
 * convert data to array
 **/
function array(mixed) {
  var k, a = [];
  if (!isUndefined(mixed)) {
    if (isObject(mixed)) {
      if (isNumber(mixed.length)) {
        a = mixed;
      } else {
        for (k in mixed) {
          a.push(mixed[k]);
        }
      }
    } else {
      a.push(mixed);
    }
  }
  return a;
}

/**
 * create a function to check a tag
 */
function ftag(tag) {
  if (tag) {
    if (isFunction(tag)) {
      return tag;
    }
    tag = array(tag);
    return function (val) {
      var i;
      if (isUndefined(val)) {
        return false;
      }
      if (isObject(val)) {
        for (i = 0; i < val.length; i++) {
          if ($.inArray(val[i], tag) >= 0) {
            return true;
          }
        }
        return false;
      }
      return $.inArray(val, tag) >= 0;
    };
  }
}


/**
 * convert mixed [ lat, lng ] objet to gm.LatLng
 **/
function toLatLng(mixed, emptyReturnMixed, noFlat) {
  var empty = emptyReturnMixed ? mixed : null;
  if (!mixed || (isString(mixed))) {
    return empty;
  }
  // defined latLng
  if (mixed.latLng) {
    return toLatLng(mixed.latLng);
  }
  // gm.LatLng object
  if (mixed instanceof gm.LatLng) {
    return mixed;
  }
  // {lat:X, lng:Y} object
  if (numeric(mixed.lat)) {
    return new gm.LatLng(mixed.lat, mixed.lng);
  }
  // [X, Y] object
  if (!noFlat && isArray(mixed)) {
    if (!numeric(mixed[0]) || !numeric(mixed[1])) {
      return empty;
    }
    return new gm.LatLng(mixed[0], mixed[1]);
  }
  return empty;
}

/**
 * convert mixed [ sw, ne ] object by gm.LatLngBounds
 **/
function toLatLngBounds(mixed) {
  var ne, sw;
  if (!mixed || mixed instanceof gm.LatLngBounds) {
    return mixed || null;
  }
  if (isArray(mixed)) {
    if (mixed.length === 2) {
      ne = toLatLng(mixed[0]);
      sw = toLatLng(mixed[1]);
    } else if (mixed.length === 4) {
      ne = toLatLng([mixed[0], mixed[1]]);
      sw = toLatLng([mixed[2], mixed[3]]);
    }
  } else {
    if (("ne" in mixed) && ("sw" in mixed)) {
      ne = toLatLng(mixed.ne);
      sw = toLatLng(mixed.sw);
    } else if (("n" in mixed) && ("e" in mixed) && ("s" in mixed) && ("w" in mixed)) {
      ne = toLatLng([mixed.n, mixed.e]);
      sw = toLatLng([mixed.s, mixed.w]);
    }
  }
  if (ne && sw) {
    return new gm.LatLngBounds(sw, ne);
  }
  return null;
}

/**
 * resolveLatLng
 **/
function resolveLatLng(ctx, method, runLatLng, args, attempt) {
  var latLng = runLatLng ? toLatLng(args.td, false, true) : false,
    conf = latLng ?  {latLng: latLng} : (args.td.address ? (isString(args.td.address) ? {address: args.td.address} : args.td.address) : false),
    cache = conf ? geocoderCache.get(conf) : false,
    self = this;
  if (conf) {
    attempt = attempt || 0; // convert undefined to int
    if (cache) {
      args.latLng = cache.results[0].geometry.location;
      args.results = cache.results;
      args.status = cache.status;
      method.apply(ctx, [args]);
    } else {
      if (conf.location) {
        conf.location = toLatLng(conf.location);
      }
      if (conf.bounds) {
        conf.bounds = toLatLngBounds(conf.bounds);
      }
      geocoder().geocode(
        conf,
        function (results, status) {
          if (status === gm.GeocoderStatus.OK) {
            geocoderCache.store(conf, {results: results, status: status});
            args.latLng = results[0].geometry.location;
            args.results = results;
            args.status = status;
            method.apply(ctx, [args]);
          } else if ((status === gm.GeocoderStatus.OVER_QUERY_LIMIT) && (attempt < defaults.queryLimit.attempt)) {
            setTimeout(
              function () {
                resolveLatLng.apply(self, [ctx, method, runLatLng, args, attempt + 1]);
              },
              defaults.queryLimit.delay + Math.floor(Math.random() * defaults.queryLimit.random)
            );
          } else {
            error("geocode failed", status, conf);
            args.latLng = args.results = false;
            args.status = status;
            method.apply(ctx, [args]);
          }
        }
      );
    }
  } else {
    args.latLng = toLatLng(args.td, false, true);
    method.apply(ctx, [args]);
  }
}

function resolveAllLatLng(list, ctx, method, args) {
  var self = this, i = -1;

  function resolve() {
    // look for next address to resolve
    do {
      i++;
    } while ((i < list.length) && !("address" in list[i]));

    // no address found, so run method
    if (i >= list.length) {
      method.apply(ctx, [args]);
      return;
    }

    resolveLatLng(
      self,
      function (args) {
        delete args.td;
        $.extend(list[i], args);
        resolve.apply(self, []); // resolve next (using apply avoid too much recursion)
      },
      true,
      {td: list[i]}
    );
  }
  resolve();
}



/**
 * geolocalise the user and return a LatLng
 **/
function geoloc(ctx, method, args) {
  var is_echo = false; // sometime, a kind of echo appear, this trick will notice once the first call is run to ignore the next one
  if (navigator && navigator.geolocation) {
    navigator.geolocation.getCurrentPosition(
      function (pos) {
        if (!is_echo) {
          is_echo = true;
          args.latLng = new gm.LatLng(pos.coords.latitude, pos.coords.longitude);
          method.apply(ctx, [args]);
        }
      },
      function () {
        if (!is_echo) {
          is_echo = true;
          args.latLng = false;
          method.apply(ctx, [args]);
        }
      },
      args.opts.getCurrentPosition
    );
  } else {
    args.latLng = false;
    method.apply(ctx, [args]);
  }
}

/**
 * Return true if get is a direct call
 * it means :
 *   - get is the only key
 *   - get has no callback
 * @param obj {Object} The request to check
 * @return {Boolean}
 */
function isDirectGet(obj) {
  var k,
    result = false;
  if (isObject(obj) && obj.hasOwnProperty("get")) {
    for (k in obj) {
      if (k !== "get") {
        return false;
      }
    }
    result = !obj.get.hasOwnProperty("callback");
  }
  return result;
}
var services = {},
  geocoderCache = new GeocoderCache();


function geocoder(){
  if (!services.geocoder) {
    services.geocoder = new gm.Geocoder();
  }
  return services.geocoder;
}
/**
 * Class GeocoderCache
 * @constructor
 */
function GeocoderCache() {
  var cache = [];

  this.get = function (request) {
    if (cache.length) {
      var i, j, k, item, eq,
        keys = getKeys(request);
      for (i = 0; i < cache.length; i++) {
        item = cache[i];
        eq = keys.length === item.keys.length;
        for (j = 0; (j < keys.length) && eq; j++) {
          k = keys[j];
          eq = k in item.request;
          if (eq) {
            if (isObject(request[k]) && ("equals" in request[k]) && isFunction(request[k])) {
              eq = request[k].equals(item.request[k]);
            } else {
              eq = request[k] === item.request[k];
            }
          }
        }
        if (eq) {
          return item.results;
        }
      }
    }
  };

  this.store = function (request, results) {
    cache.push({request: request, keys: getKeys(request), results: results});
  };
}
/**
 * Class Stack
 * @constructor
 */
function Stack() {
  var st = [],
    self = this;

  self.empty = function () {
    return !st.length;
  };

  self.add = function (v) {
    st.push(v);
  };

  self.get = function () {
    return st.length ? st[0] : false;
  };

  self.ack = function () {
    st.shift();
  };
}
/**
 * Class Store
 * @constructor
 */
function Store() {
  var store = {}, // name => [id, ...]
    objects = {}, // id => object
    self = this;

  function normalize(res) {
    return {
      id: res.id,
      name: res.name,
      object: res.obj,
      tag: res.tag,
      data: res.data
    };
  }

  /**
   * add a mixed to the store
   **/
  self.add = function (args, name, obj, sub) {
    var td = args.td || {},
      id = globalId(td.id);
    if (!store[name]) {
      store[name] = [];
    }
    if (id in objects) { // object already exists: remove it
      self.clearById(id);
    }
    objects[id] = {obj: obj, sub: sub, name: name, id: id, tag: td.tag, data: td.data};
    store[name].push(id);
    return id;
  };

  /**
   * return a stored object by its id
   **/
  self.getById = function (id, sub, full) {
    var result = false;
    if (id in objects) {
      if (sub) {
        result = objects[id].sub;
      } else if (full) {
        result = normalize(objects[id]);
      } else {
        result = objects[id].obj;
      }
    }
    return result;
  };

  /**
   * return a stored value
   **/
  self.get = function (name, last, tag, full) {
    var n, id, check = ftag(tag);
    if (!store[name] || !store[name].length) {
      return null;
    }
    n = store[name].length;
    while (n) {
      n--;
      id = store[name][last ? n : store[name].length - n - 1];
      if (id && objects[id]) {
        if (check && !check(objects[id].tag)) {
          continue;
        }
        return full ? normalize(objects[id]) : objects[id].obj;
      }
    }
    return null;
  };

  /**
   * return all stored values
   **/
  self.all = function (name, tag, full) {
    var result = [],
      check = ftag(tag),
      find = function (n) {
        var i, id;
        for (i = 0; i < store[n].length; i++) {
          id = store[n][i];
          if (id && objects[id]) {
            if (check && !check(objects[id].tag)) {
              continue;
            }
            result.push(full ? normalize(objects[id]) : objects[id].obj);
          }
        }
      };
    if (name in store) {
      find(name);
    } else if (isUndefined(name)) { // internal use only
      for (name in store) {
        find(name);
      }
    }
    return result;
  };

  /**
   * hide and remove an object
   **/
  function rm(obj) {
    // Google maps element
    if (isFunction(obj.setMap)) {
      obj.setMap(null);
    }
    // jQuery
    if (isFunction(obj.remove)) {
      obj.remove();
    }
    // internal (cluster)
    if (isFunction(obj.free)) {
      obj.free();
    }
    obj = null;
  }

  /**
   * remove one object from the store
   **/
  self.rm = function (name, check, pop) {
    var idx, id;
    if (!store[name]) {
      return false;
    }
    if (check) {
      if (pop) {
        for (idx = store[name].length - 1; idx >= 0; idx--) {
          id = store[name][idx];
          if (check(objects[id].tag)) {
            break;
          }
        }
      } else {
        for (idx = 0; idx < store[name].length; idx++) {
          id = store[name][idx];
          if (check(objects[id].tag)) {
            break;
          }
        }
      }
    } else {
      idx = pop ? store[name].length - 1 : 0;
    }
    if (!(idx in store[name])) {
      return false;
    }
    return self.clearById(store[name][idx], idx);
  };

  /**
   * remove object from the store by its id
   **/
  self.clearById = function (id, idx) {
    if (id in objects) {
      var i, name = objects[id].name;
      for (i = 0; isUndefined(idx) && i < store[name].length; i++) {
        if (id === store[name][i]) {
          idx = i;
        }
      }
      rm(objects[id].obj);
      if (objects[id].sub) {
        rm(objects[id].sub);
      }
      delete objects[id];
      store[name].splice(idx, 1);
      return true;
    }
    return false;
  };

  /**
   * return an object from a container object in the store by its id
   * ! for now, only cluster manage this feature
   **/
  self.objGetById = function (id) {
    var result, idx;
    if (store.clusterer) {
      for (idx in store.clusterer) {
        if ((result = objects[store.clusterer[idx]].obj.getById(id)) !== false) {
          return result;
        }
      }
    }
    return false;
  };

  /**
   * remove object from a container object in the store by its id
   * ! for now, only cluster manage this feature
   **/
  self.objClearById = function (id) {
    var idx;
    if (store.clusterer) {
      for (idx in store.clusterer) {
        if (objects[store.clusterer[idx]].obj.clearById(id)) {
          return true;
        }
      }
    }
    return null;
  };

  /**
   * remove objects from the store
   **/
  self.clear = function (list, last, first, tag) {
    var k, i, name,
      check = ftag(tag);
    if (!list || !list.length) {
      list = [];
      for (k in store) {
        list.push(k);
      }
    } else {
      list = array(list);
    }
    for (i = 0; i < list.length; i++) {
      name = list[i];
      if (last) {
        self.rm(name, check, true);
      } else if (first) {
        self.rm(name, check, false);
      } else { // all
        while (self.rm(name, check, false)) {
        }
      }
    }
  };

  /**
   * remove object from a container object in the store by its tags
   * ! for now, only cluster manage this feature
   **/
  self.objClear = function (list, last, first, tag) {
    var idx;
    if (store.clusterer && ($.inArray("marker", list) >= 0 || !list.length)) {
      for (idx in store.clusterer) {
        objects[store.clusterer[idx]].obj.clear(last, first, tag);
      }
    }
  };
}
/**
 * Class Task
 * @param ctx
 * @param onEnd
 * @param td
 * @constructor
 */
function Task(ctx, onEnd, td) {
  var session = {},
    self = this,
    current,
    resolve = {
      latLng: { // function => bool (=> address = latLng)
        map: false,
        marker: false,
        infowindow: false,
        circle: false,
        overlay: false,
        getlatlng: false,
        getmaxzoom: false,
        getelevation: false,
        streetviewpanorama: false,
        getaddress: true
      },
      geoloc: {
        getgeoloc: true
      }
    };

  function unify(td) {
    var result = {};
    result[td] = {};
    return result;
  }

  if (isString(td)) {
    td =  unify(td);
  }

  function next() {
    var k;
    for (k in td) {
      if (td.hasOwnProperty(k) && !session.hasOwnProperty(k)) {
        return k;
      }
    }
  }

  self.run = function () {
    var k, opts;
    while (k = next()) {
      if (isFunction(ctx[k])) {
        current = k;
        opts = $.extend(true, {}, defaults[k] || {}, td[k].options || {});
        if (k in resolve.latLng) {
          if (td[k].values) {
            resolveAllLatLng(td[k].values, ctx, ctx[k], {td: td[k], opts: opts, session: session});
          } else {
            resolveLatLng(ctx, ctx[k], resolve.latLng[k], {td: td[k], opts: opts, session: session});
          }
        } else if (k in resolve.geoloc) {
          geoloc(ctx, ctx[k], {td: td[k], opts: opts, session: session});
        } else {
          ctx[k].apply(ctx, [{td: td[k], opts: opts, session: session}]);
        }
        return; // wait until ack
      } else {
        session[k] = null;
      }
    }
    onEnd.apply(ctx, [td, session]);
  };

  self.ack = function(result){
    session[current] = result;
    self.run.apply(self, []);
  };
}

function directionsService(){
  if (!services.ds) {
    services.ds = new gm.DirectionsService();
  }
  return services.ds;
}

function distanceMatrixService() {
  if (!services.dms) {
    services.dms = new gm.DistanceMatrixService();
  }
  return services.dms;
}

function maxZoomService() {
  if (!services.mzs) {
    services.mzs = new gm.MaxZoomService();
  }
  return services.mzs;
}

function elevationService() {
  if (!services.es) {
    services.es = new gm.ElevationService();
  }
  return services.es;
}

  /**
   * Usefull to get a projection
   * => done in a function, to let dead-code analyser works without google library loaded
   **/
  function newEmptyOverlay(map, radius) {
    function Overlay() {
      var self = this;
      self.onAdd = function () {};
      self.onRemove = function () {};
      self.draw = function () {};
      return defaults.classes.OverlayView.apply(self, []);
    }
    Overlay.prototype = defaults.classes.OverlayView.prototype;
    var obj = new Overlay();
    obj.setMap(map);
    return obj;
  }

/**
 * Class InternalClusterer
 * This class manage clusters thanks to "td" objects
 *
 * Note:
 * Individuals marker are created on the fly thanks to the td objects, they are
 * first set to null to keep the indexes synchronised with the td list
 * This is the "display" function, set by the gmap3 object, which uses theses data
 * to create markers when clusters are not required
 * To remove a marker, the objects are deleted and set not null in arrays
 *    markers[key]
 *      = null : marker exist but has not been displayed yet
 *      = false : marker has been removed
 **/
function InternalClusterer($container, map, raw) {
  var timer, projection,
    ffilter, fdisplay, ferror, // callback function
    updating = false,
    updated = false,
    redrawing = false,
    ready = false,
    enabled = true,
    self = this,
    events =  [],
    store = {},   // combin of index (id1-id2-...) => object
    ids = {},     // unique id => index
    idxs = {},    // index => unique id
    markers = [], // index => marker
    tds = [],   // index => td or null if removed
    values = [],  // index => value
    overlay = newEmptyOverlay(map, raw.radius);

  main();

  function prepareMarker(index) {
    if (!markers[index]) {
      delete tds[index].options.map;
      markers[index] = new defaults.classes.Marker(tds[index].options);
      attachEvents($container, {td: tds[index]}, markers[index], tds[index].id);
    }
  }

  /**
   * return a marker by its id, null if not yet displayed and false if no exist or removed
   **/
  self.getById = function (id) {
    if (id in ids) {
      prepareMarker(ids[id]);
      return  markers[ids[id]];
    }
    return false;
  };

  /**
   * remove one object from the store
   **/
  self.rm = function (id) {
    var index = ids[id];
    if (markers[index]) { // can be null
      markers[index].setMap(null);
    }
    delete markers[index];
    markers[index] = false;

    delete tds[index];
    tds[index] = false;

    delete values[index];
    values[index] = false;

    delete ids[id];
    delete idxs[index];
    updated = true;
  };

  /**
   * remove a marker by its id
   **/
  self.clearById = function (id) {
    if (id in ids){
      self.rm(id);
      return true;
    }
  };

  /**
   * remove objects from the store
   **/
  self.clear = function (last, first, tag) {
    var start, stop, step, index, i,
      list = [],
      check = ftag(tag);
    if (last) {
      start = tds.length - 1;
      stop = -1;
      step = -1;
    } else {
      start = 0;
      stop =  tds.length;
      step = 1;
    }
    for (index = start; index !== stop; index += step) {
      if (tds[index]) {
        if (!check || check(tds[index].tag)) {
          list.push(idxs[index]);
          if (first || last) {
            break;
          }
        }
      }
    }
    for (i = 0; i < list.length; i++) {
      self.rm(list[i]);
    }
  };

  // add a "marker td" to the cluster
  self.add = function (td, value) {
    td.id = globalId(td.id);
    self.clearById(td.id);
    ids[td.id] = markers.length;
    idxs[markers.length] = td.id;
    markers.push(null); // null = marker not yet created / displayed
    tds.push(td);
    values.push(value);
    updated = true;
  };

  // add a real marker to the cluster
  self.addMarker = function (marker, td) {
    td = td || {};
    td.id = globalId(td.id);
    self.clearById(td.id);
    if (!td.options) {
      td.options = {};
    }
    td.options.position = marker.getPosition();
    attachEvents($container, {td: td}, marker, td.id);
    ids[td.id] = markers.length;
    idxs[markers.length] = td.id;
    markers.push(marker);
    tds.push(td);
    values.push(td.data || {});
    updated = true;
  };

  // return a "marker td" by its index
  self.td = function (index) {
    return tds[index];
  };

  // return a "marker value" by its index
  self.value = function (index) {
    return values[index];
  };

  // return a marker by its index
  self.marker = function (index) {
    if (index in markers) {
      prepareMarker(index);
      return  markers[index];
    }
    return false;
  };

  // return a marker by its index
  self.markerIsSet = function (index) {
    return Boolean(markers[index]);
  };

  // store a new marker instead if the default "false"
  self.setMarker = function (index, marker) {
    markers[index] = marker;
  };

  // link the visible overlay to the logical data (to hide overlays later)
  self.store = function (cluster, obj, shadow) {
    store[cluster.ref] = {obj: obj, shadow: shadow};
  };

  // free all objects
  self.free = function () {
    var i;
    for(i = 0; i < events.length; i++) {
      gm.event.removeListener(events[i]);
    }
    events = [];

    $.each(store, function (key) {
      flush(key);
    });
    store = {};

    $.each(tds, function (i) {
      tds[i] = null;
    });
    tds = [];

    $.each(markers, function (i) {
      if (markers[i]) { // false = removed
        markers[i].setMap(null);
        delete markers[i];
      }
    });
    markers = [];

    $.each(values, function (i) {
      delete values[i];
    });
    values = [];

    ids = {};
    idxs = {};
  };

  // link the display function
  self.filter = function (f) {
    ffilter = f;
    redraw();
  };

  // enable/disable the clustering feature
  self.enable = function (value) {
    if (enabled !== value) {
      enabled = value;
      redraw();
    }
  };

  // link the display function
  self.display = function (f) {
    fdisplay = f;
  };

  // link the errorfunction
  self.error = function (f) {
    ferror = f;
  };

  // lock the redraw
  self.beginUpdate = function () {
    updating = true;
  };

  // unlock the redraw
  self.endUpdate = function () {
    updating = false;
    if (updated) {
      redraw();
    }
  };

  // extends current bounds with internal markers
  self.autofit = function (bounds) {
    var i;
    for (i = 0; i < tds.length; i++) {
      if (tds[i]) {
        bounds.extend(tds[i].options.position);
      }
    }
  };

  // bind events
  function main() {
    projection = overlay.getProjection();
    if (!projection) {
      setTimeout(function () { main.apply(self, []); }, 25);
      return;
    }
    ready = true;
    events.push(gm.event.addListener(map, "zoom_changed", delayRedraw));
    events.push(gm.event.addListener(map, "bounds_changed", delayRedraw));
    redraw();
  }

  // flush overlays
  function flush(key) {
    if (isObject(store[key])) { // is overlay
      if (isFunction(store[key].obj.setMap)) {
        store[key].obj.setMap(null);
      }
      if (isFunction(store[key].obj.remove)) {
        store[key].obj.remove();
      }
      if (isFunction(store[key].shadow.remove)) {
        store[key].obj.remove();
      }
      if (isFunction(store[key].shadow.setMap)) {
        store[key].shadow.setMap(null);
      }
      delete store[key].obj;
      delete store[key].shadow;
    } else if (markers[key]) { // marker not removed
      markers[key].setMap(null);
      // don't remove the marker object, it may be displayed later
    }
    delete store[key];
  }

  /**
   * return the distance between 2 latLng couple into meters
   * Params :
   *  Lat1, Lng1, Lat2, Lng2
   *  LatLng1, Lat2, Lng2
   *  Lat1, Lng1, LatLng2
   *  LatLng1, LatLng2
   **/
  function distanceInMeter() {
    var lat1, lat2, lng1, lng2, e, f, g, h,
      cos = Math.cos,
      sin = Math.sin,
      args = arguments;
    if (args[0] instanceof gm.LatLng) {
      lat1 = args[0].lat();
      lng1 = args[0].lng();
      if (args[1] instanceof gm.LatLng) {
        lat2 = args[1].lat();
        lng2 = args[1].lng();
      } else {
        lat2 = args[1];
        lng2 = args[2];
      }
    } else {
      lat1 = args[0];
      lng1 = args[1];
      if (args[2] instanceof gm.LatLng) {
        lat2 = args[2].lat();
        lng2 = args[2].lng();
      } else {
        lat2 = args[2];
        lng2 = args[3];
      }
    }
    e = Math.PI * lat1 / 180;
    f = Math.PI * lng1 / 180;
    g = Math.PI * lat2 / 180;
    h = Math.PI * lng2 / 180;
    return 1000 * 6371 * Math.acos(Math.min(cos(e) * cos(g) * cos(f) * cos(h) + cos(e) * sin(f) * cos(g) * sin(h) + sin(e) * sin(g), 1));
  }

  // extend the visible bounds
  function extendsMapBounds() {
    var radius = distanceInMeter(map.getCenter(), map.getBounds().getNorthEast()),
      circle = new gm.Circle({
        center: map.getCenter(),
        radius: 1.25 * radius // + 25%
      });
    return circle.getBounds();
  }

  // return an object where keys are store keys
  function getStoreKeys() {
    var k,
      keys = {};
    for (k in store) {
      keys[k] = true;
    }
    return keys;
  }

  // async the delay function
  function delayRedraw() {
    clearTimeout(timer);
    timer = setTimeout(redraw, 25);
  }

  // generate bounds extended by radius
  function extendsBounds(latLng) {
    var p = projection.fromLatLngToDivPixel(latLng),
      ne = projection.fromDivPixelToLatLng(new gm.Point(p.x + raw.radius, p.y - raw.radius)),
      sw = projection.fromDivPixelToLatLng(new gm.Point(p.x - raw.radius, p.y + raw.radius));
    return new gm.LatLngBounds(sw, ne);
  }

  // run the clustering process and call the display function
  function redraw() {
    if (updating || redrawing || !ready) {
      return;
    }

    var i, j, k, indexes, check = false, bounds, cluster, position, previous, lat, lng, loop,
      keys = [],
      used = {},
      zoom = map.getZoom(),
      forceDisabled = ("maxZoom" in raw) && (zoom > raw.maxZoom),
      previousKeys = getStoreKeys();

    // reset flag
    updated = false;

    if (zoom > 3) {
      // extend the bounds of the visible map to manage clusters near the boundaries
      bounds = extendsMapBounds();

      // check contain only if boundaries are valid
      check = bounds.getSouthWest().lng() < bounds.getNorthEast().lng();
    }

    // calculate positions of "visibles" markers (in extended bounds)
    for (i = 0; i < tds.length; i++) {
      if (tds[i] && (!check || bounds.contains(tds[i].options.position)) && (!ffilter || ffilter(values[i]))) {
        keys.push(i);
      }
    }

    // for each "visible" marker, search its neighbors to create a cluster
    // we can't do a classical "for" loop, because, analysis can bypass a marker while focusing on cluster
    while (1) {
      i = 0;
      while (used[i] && (i < keys.length)) { // look for the next marker not used
        i++;
      }
      if (i === keys.length) {
        break;
      }

      indexes = [];

      if (enabled && !forceDisabled) {
        loop = 10;
        do {
          previous = indexes;
          indexes = [];
          loop--;

          if (previous.length) {
            position = bounds.getCenter();
          } else {
            position = tds[keys[i]].options.position;
          }
          bounds = extendsBounds(position);

          for (j = i; j < keys.length; j++) {
            if (used[j]) {
              continue;
            }
            if (bounds.contains(tds[keys[j]].options.position)) {
              indexes.push(j);
            }
          }
        } while ((previous.length < indexes.length) && (indexes.length > 1) && loop);
      } else {
        for (j = i; j < keys.length; j++) {
          if (!used[j]) {
            indexes.push(j);
            break;
          }
        }
      }

      cluster = {indexes: [], ref: []};
      lat = lng = 0;
      for (k = 0; k < indexes.length; k++) {
        used[indexes[k]] = true;
        cluster.indexes.push(keys[indexes[k]]);
        cluster.ref.push(keys[indexes[k]]);
        lat += tds[keys[indexes[k]]].options.position.lat();
        lng += tds[keys[indexes[k]]].options.position.lng();
      }
      lat /= indexes.length;
      lng /= indexes.length;
      cluster.latLng = new gm.LatLng(lat, lng);

      cluster.ref = cluster.ref.join("-");

      if (cluster.ref in previousKeys) { // cluster doesn't change
        delete previousKeys[cluster.ref]; // remove this entry, these still in this array will be removed
      } else { // cluster is new
        if (indexes.length === 1) { // alone markers are not stored, so need to keep the key (else, will be displayed every time and marker will blink)
          store[cluster.ref] = true;
        }
        fdisplay(cluster);
      }
    }

    // flush the previous overlays which are not still used
    $.each(previousKeys, function (key) {
      flush(key);
    });
    redrawing = false;
  }
}
/**
 * Class Clusterer
 * a facade with limited method for external use
 **/
function Clusterer(id, internalClusterer) {
  var self = this;
  self.id = function () {
    return id;
  };
  self.filter = function (f) {
    internalClusterer.filter(f);
  };
  self.enable = function () {
    internalClusterer.enable(true);
  };
  self.disable = function () {
    internalClusterer.enable(false);
  };
  self.add = function (marker, td, lock) {
    if (!lock) {
      internalClusterer.beginUpdate();
    }
    internalClusterer.addMarker(marker, td);
    if (!lock) {
      internalClusterer.endUpdate();
    }
  };
  self.getById = function (id) {
    return internalClusterer.getById(id);
  };
  self.clearById = function (id, lock) {
    var result;
    if (!lock) {
      internalClusterer.beginUpdate();
    }
    result = internalClusterer.clearById(id);
    if (!lock) {
      internalClusterer.endUpdate();
    }
    return result;
  };
  self.clear = function (last, first, tag, lock) {
    if (!lock) {
      internalClusterer.beginUpdate();
    }
    internalClusterer.clear(last, first, tag);
    if (!lock) {
      internalClusterer.endUpdate();
    }
  };
}

/**
 * Class OverlayView
 * @constructor
 */
function OverlayView(map, opts, latLng, $div) {
  var self = this,
    listeners = [];

  defaults.classes.OverlayView.call(self);
  self.setMap(map);

  self.onAdd = function () {
    var panes = self.getPanes();
    if (opts.pane in panes) {
      $(panes[opts.pane]).append($div);
    }
    $.each("dblclick click mouseover mousemove mouseout mouseup mousedown".split(" "), function (i, name) {
      listeners.push(
        gm.event.addDomListener($div[0], name, function (e) {
          $.Event(e).stopPropagation();
          gm.event.trigger(self, name, [e]);
          self.draw();
        })
      );
    });
    listeners.push(
      gm.event.addDomListener($div[0], "contextmenu", function (e) {
        $.Event(e).stopPropagation();
        gm.event.trigger(self, "rightclick", [e]);
        self.draw();
      })
    );
  };

  self.getPosition = function () {
    return latLng;
  };

  self.setPosition = function (newLatLng) {
    latLng = newLatLng;
    self.draw();
  };

  self.draw = function () {
    var ps = self.getProjection().fromLatLngToDivPixel(latLng);
    $div
      .css("left", (ps.x + opts.offset.x) + "px")
      .css("top", (ps.y + opts.offset.y) + "px");
  };

  self.onRemove = function () {
    var i;
    for (i = 0; i < listeners.length; i++) {
      gm.event.removeListener(listeners[i]);
    }
    $div.remove();
  };

  self.hide = function () {
    $div.hide();
  };

  self.show = function () {
    $div.show();
  };

  self.toggle = function () {
    if ($div) {
      if ($div.is(":visible")) {
        self.show();
      } else {
        self.hide();
      }
    }
  };

  self.toggleDOM = function () {
    self.setMap(self.getMap() ? null : map);
  };

  self.getDOMElement = function () {
    return $div[0];
  };
}

function Gmap3($this) {
  var self = this,
    stack = new Stack(),
    store = new Store(),
    map = null,
    task;

  /**
   * if not running, start next action in stack
   **/
  function run() {
    if (!task && (task = stack.get())) {
      task.run();
    }
  }

  /**
   * called when action in finished, to acknoledge the current in stack and start next one
   **/
  function end() {
    task = null;
    stack.ack();
    run.call(self); // restart to high level scope
  }

//-----------------------------------------------------------------------//
// Tools
//-----------------------------------------------------------------------//

  /**
   * execute callback functions
   **/
  function callback(args) {
    var params,
      cb = args.td.callback;
    if (cb) {
      params = Array.prototype.slice.call(arguments, 1);
      if (isFunction(cb)) {
        cb.apply($this, params);
      } else if (isArray(cb)) {
        if (isFunction(cb[1])) {
          cb[1].apply(cb[0], params);
        }
      }
    }
  }

  /**
   * execute ending functions
   **/
  function manageEnd(args, obj, id) {
    if (id) {
      attachEvents($this, args, obj, id);
    }
    callback(args, obj);
    task.ack(obj);
  }

  /**
   * initialize the map if not yet initialized
   **/
  function newMap(latLng, args) {
    args = args || {};
    var opts = args.td && args.td.options ? args.td.options : 0;
    if (map) {
      if (opts) {
        if (opts.center) {
          opts.center = toLatLng(opts.center);
        }
        map.setOptions(opts);
      }
    } else {
      opts = args.opts || $.extend(true, {}, defaults.map, opts || {});
      opts.center = latLng || toLatLng(opts.center);
      map = new defaults.classes.Map($this.get(0), opts);
    }
  }

  /**
   * store actions to execute in a stack manager
   **/
  self._plan = function (list) {
    var k;
    for (k = 0; k < list.length; k++) {
      stack.add(new Task(self, end, list[k]));
    }
    run();
  };

  /**
   * Initialize gm.Map object
   **/
  self.map = function (args) {
    newMap(args.latLng, args);
    attachEvents($this, args, map);
    manageEnd(args, map);
  };

  /**
   * destroy an existing instance
   **/
  self.destroy = function (args) {
    store.clear();
    $this.empty();
    if (map) {
      map = null;
    }
    manageEnd(args, true);
  };

  /**
   * add an overlay
   **/
  self.overlay = function (args, internal) {
    var objs = [],
      multiple = "values" in args.td;
    if (!multiple) {
      args.td.values = [{latLng: args.latLng, options: args.opts}];
    }
    if (!args.td.values.length) {
      manageEnd(args, false);
      return;
    }
    if (!OverlayView.__initialised) {
      OverlayView.prototype = new defaults.classes.OverlayView();
      OverlayView.__initialised = true;
    }
    $.each(args.td.values, function (i, value) {
      var id, obj, td = tuple(args, value),
        $div = $(document.createElement("div")).css({
          border: "none",
          borderWidth: 0,
          position: "absolute"
        });
      $div.append(td.options.content);
      obj = new OverlayView(map, td.options, toLatLng(td) || toLatLng(value), $div);
      objs.push(obj);
      $div = null; // memory leak
      if (!internal) {
        id = store.add(args, "overlay", obj);
        attachEvents($this, {td: td}, obj, id);
      }
    });
    if (internal) {
      return objs[0];
    }
    manageEnd(args, multiple ? objs : objs[0]);
  };

  /**
   * Create an InternalClusterer object
   **/
  function createClusterer(raw) {
    var internalClusterer = new InternalClusterer($this, map, raw),
      td = {},
      styles = {},
      thresholds = [],
      isInt = /^[0-9]+$/,
      calculator,
      k;

    for (k in raw) {
      if (isInt.test(k)) {
        thresholds.push(1 * k); // cast to int
        styles[k] = raw[k];
        styles[k].width = styles[k].width || 0;
        styles[k].height = styles[k].height || 0;
      } else {
        td[k] = raw[k];
      }
    }
    thresholds.sort(function (a, b) { return a > b; });

    // external calculator
    if (td.calculator) {
      calculator = function (indexes) {
        var data = [];
        $.each(indexes, function (i, index) {
          data.push(internalClusterer.value(index));
        });
        return td.calculator.apply($this, [data]);
      };
    } else {
      calculator = function (indexes) {
        return indexes.length;
      };
    }

    // set error function
    internalClusterer.error(function () {
      error.apply(self, arguments);
    });

    // set display function
    internalClusterer.display(function (cluster) {
      var i, style, atd, obj, offset, shadow,
        cnt = calculator(cluster.indexes);

      // look for the style to use
      if (raw.force || cnt > 1) {
        for (i = 0; i < thresholds.length; i++) {
          if (thresholds[i] <= cnt) {
            style = styles[thresholds[i]];
          }
        }
      }

      if (style) {
        offset = style.offset || [-style.width/2, -style.height/2];
        // create a custom overlay command
        // nb: 2 extends are faster self a deeper extend
        atd = $.extend({}, td);
        atd.options = $.extend({
            pane: "overlayLayer",
            content: style.content ? style.content.replace("CLUSTER_COUNT", cnt) : "",
            offset: {
              x: ("x" in offset ? offset.x : offset[0]) || 0,
              y: ("y" in offset ? offset.y : offset[1]) || 0
            }
          },
          td.options || {});

        obj = self.overlay({td: atd, opts: atd.options, latLng: toLatLng(cluster)}, true);

        atd.options.pane = "floatShadow";
        atd.options.content = $(document.createElement("div")).width(style.width + "px").height(style.height + "px").css({cursor: "pointer"});
        shadow = self.overlay({td: atd, opts: atd.options, latLng: toLatLng(cluster)}, true);

        // store data to the clusterer
        td.data = {
          latLng: toLatLng(cluster),
          markers:[]
        };
        $.each(cluster.indexes, function(i, index){
          td.data.markers.push(internalClusterer.value(index));
          if (internalClusterer.markerIsSet(index)){
            internalClusterer.marker(index).setMap(null);
          }
        });
        attachEvents($this, {td: td}, shadow, undef, {main: obj, shadow: shadow});
        internalClusterer.store(cluster, obj, shadow);
      } else {
        $.each(cluster.indexes, function (i, index) {
          internalClusterer.marker(index).setMap(map);
        });
      }
    });

    return internalClusterer;
  }

  /**
   *  add a marker
   **/
  self.marker = function (args) {
    var objs,
      clusterer, internalClusterer,
      multiple = "values" in args.td,
      init = !map;
    if (!multiple) {
      args.opts.position = args.latLng || toLatLng(args.opts.position);
      args.td.values = [{options: args.opts}];
    }
    if (!args.td.values.length) {
      manageEnd(args, false);
      return;
    }
    if (init) {
      newMap();
    }
    if (args.td.cluster && !map.getBounds()) { // map not initialised => bounds not available : wait for map if clustering feature is required
      gm.event.addListenerOnce(map, "bounds_changed", function () { self.marker.apply(self, [args]); });
      return;
    }
    if (args.td.cluster) {
      if (args.td.cluster instanceof Clusterer) {
        clusterer = args.td.cluster;
        internalClusterer = store.getById(clusterer.id(), true);
      } else {
        internalClusterer = createClusterer(args.td.cluster);
        clusterer = new Clusterer(globalId(args.td.id, true), internalClusterer);
        store.add(args, "clusterer", clusterer, internalClusterer);
      }
      internalClusterer.beginUpdate();

      $.each(args.td.values, function (i, value) {
        var td = tuple(args, value);
        td.options.position = td.options.position ? toLatLng(td.options.position) : toLatLng(value);
        if (td.options.position) {
          td.options.map = map;
          if (init) {
            map.setCenter(td.options.position);
            init = false;
          }
          internalClusterer.add(td, value);
        }
      });

      internalClusterer.endUpdate();
      manageEnd(args, clusterer);

    } else {
      objs = [];
      $.each(args.td.values, function (i, value) {
        var id, obj,
          td = tuple(args, value);
        td.options.position = td.options.position ? toLatLng(td.options.position) : toLatLng(value);
        if (td.options.position) {
          td.options.map = map;
          if (init) {
            map.setCenter(td.options.position);
            init = false;
          }
          obj = new defaults.classes.Marker(td.options);
          objs.push(obj);
          id = store.add({td: td}, "marker", obj);
          attachEvents($this, {td: td}, obj, id);
        }
      });
      manageEnd(args, multiple ? objs : objs[0]);
    }
  };

  /**
   * return a route
   **/
  self.getroute = function (args) {
    args.opts.origin = toLatLng(args.opts.origin, true);
    args.opts.destination = toLatLng(args.opts.destination, true);
    directionsService().route(
      args.opts,
      function (results, status) {
        callback(args, status === gm.DirectionsStatus.OK ? results : false, status);
        task.ack();
      }
    );
  };

  /**
   * return the distance between an origin and a destination
   *
   **/
  self.getdistance = function (args) {
    var i;
    args.opts.origins = array(args.opts.origins);
    for (i = 0; i < args.opts.origins.length; i++) {
      args.opts.origins[i] = toLatLng(args.opts.origins[i], true);
    }
    args.opts.destinations = array(args.opts.destinations);
    for (i = 0; i < args.opts.destinations.length; i++) {
      args.opts.destinations[i] = toLatLng(args.opts.destinations[i], true);
    }
    distanceMatrixService().getDistanceMatrix(
      args.opts,
      function (results, status) {
        callback(args, status === gm.DistanceMatrixStatus.OK ? results : false, status);
        task.ack();
      }
    );
  };

  /**
   * add an infowindow
   **/
  self.infowindow = function (args) {
    var objs = [],
      multiple = "values" in args.td;
    if (!multiple) {
      if (args.latLng) {
        args.opts.position = args.latLng;
      }
      args.td.values = [{options: args.opts}];
    }
    $.each(args.td.values, function (i, value) {
      var id, obj,
        td = tuple(args, value);
      td.options.position = td.options.position ? toLatLng(td.options.position) : toLatLng(value.latLng);
      if (!map) {
        newMap(td.options.position);
      }
      obj = new defaults.classes.InfoWindow(td.options);
      if (obj && (isUndefined(td.open) || td.open)) {
        if (multiple) {
          obj.open(map, td.anchor || undef);
        } else {
          obj.open(map, td.anchor || (args.latLng ? undef : (args.session.marker ? args.session.marker : undef)));
        }
      }
      objs.push(obj);
      id = store.add({td: td}, "infowindow", obj);
      attachEvents($this, {td: td}, obj, id);
    });
    manageEnd(args, multiple ? objs : objs[0]);
  };

  /**
   * add a circle
   **/
  self.circle = function (args) {
    var objs = [],
      multiple = "values" in args.td;
    if (!multiple) {
      args.opts.center = args.latLng || toLatLng(args.opts.center);
      args.td.values = [{options: args.opts}];
    }
    if (!args.td.values.length) {
      manageEnd(args, false);
      return;
    }
    $.each(args.td.values, function (i, value) {
      var id, obj,
        td = tuple(args, value);
      td.options.center = td.options.center ? toLatLng(td.options.center) : toLatLng(value);
      if (!map) {
        newMap(td.options.center);
      }
      td.options.map = map;
      obj = new defaults.classes.Circle(td.options);
      objs.push(obj);
      id = store.add({td: td}, "circle", obj);
      attachEvents($this, {td: td}, obj, id);
    });
    manageEnd(args, multiple ? objs : objs[0]);
  };

  /**
   * returns address structure from latlng
   **/
  self.getaddress = function (args) {
    callback(args, args.results, args.status);
    task.ack();
  };

  /**
   * returns latlng from an address
   **/
  self.getlatlng = function (args) {
    callback(args, args.results, args.status);
    task.ack();
  };

  /**
   * return the max zoom of a location
   **/
  self.getmaxzoom = function (args) {
    maxZoomService().getMaxZoomAtLatLng(
      args.latLng,
      function (result) {
        callback(args, result.status === gm.MaxZoomStatus.OK ? result.zoom : false, status);
        task.ack();
      }
    );
  };

  /**
   * return the elevation of a location
   **/
  self.getelevation = function (args) {
    var i,
      locations = [],
      f = function (results, status) {
        callback(args, status === gm.ElevationStatus.OK ? results : false, status);
        task.ack();
      };

    if (args.latLng) {
      locations.push(args.latLng);
    } else {
      locations = array(args.td.locations || []);
      for (i = 0; i < locations.length; i++) {
        locations[i] = toLatLng(locations[i]);
      }
    }
    if (locations.length) {
      elevationService().getElevationForLocations({locations: locations}, f);
    } else {
      if (args.td.path && args.td.path.length) {
        for (i = 0; i < args.td.path.length; i++) {
          locations.push(toLatLng(args.td.path[i]));
        }
      }
      if (locations.length) {
        elevationService().getElevationAlongPath({path: locations, samples:args.td.samples}, f);
      } else {
        task.ack();
      }
    }
  };

  /**
   * define defaults values
   **/
  self.defaults = function (args) {
    $.each(args.td, function(name, value) {
      if (isObject(defaults[name])) {
        defaults[name] = $.extend({}, defaults[name], value);
      } else {
        defaults[name] = value;
      }
    });
    task.ack(true);
  };

  /**
   * add a rectangle
   **/
  self.rectangle = function (args) {
    var objs = [],
      multiple = "values" in args.td;
    if (!multiple) {
      args.td.values = [{options: args.opts}];
    }
    if (!args.td.values.length) {
      manageEnd(args, false);
      return;
    }
    $.each(args.td.values, function (i, value) {
      var id, obj,
        td = tuple(args, value);
      td.options.bounds = td.options.bounds ? toLatLngBounds(td.options.bounds) : toLatLngBounds(value);
      if (!map) {
        newMap(td.options.bounds.getCenter());
      }
      td.options.map = map;

      obj = new defaults.classes.Rectangle(td.options);
      objs.push(obj);
      id = store.add({td: td}, "rectangle", obj);
      attachEvents($this, {td: td}, obj, id);
    });
    manageEnd(args, multiple ? objs : objs[0]);
  };

  /**
   * add a polygone / polyline
   **/
  function poly(args, poly, path) {
    var objs = [],
      multiple = "values" in args.td;
    if (!multiple) {
      args.td.values = [{options: args.opts}];
    }
    if (!args.td.values.length) {
      manageEnd(args, false);
      return;
    }
    newMap();
    $.each(args.td.values, function (_, value) {
      var id, i, j, obj,
        td = tuple(args, value);
      if (td.options[path]) {
        if (td.options[path][0][0] && isArray(td.options[path][0][0])) {
          for (i = 0; i < td.options[path].length; i++) {
            for (j = 0; j < td.options[path][i].length; j++) {
              td.options[path][i][j] = toLatLng(td.options[path][i][j]);
            }
          }
        } else {
          for (i = 0; i < td.options[path].length; i++) {
            td.options[path][i] = toLatLng(td.options[path][i]);
          }
        }
      }
      td.options.map = map;
      obj = new gm[poly](td.options);
      objs.push(obj);
      id = store.add({td: td}, poly.toLowerCase(), obj);
      attachEvents($this, {td: td}, obj, id);
    });
    manageEnd(args, multiple ? objs : objs[0]);
  }

  self.polyline = function (args) {
    poly(args, "Polyline", "path");
  };

  self.polygon = function (args) {
    poly(args, "Polygon", "paths");
  };

  /**
   * add a traffic layer
   **/
  self.trafficlayer = function (args) {
    newMap();
    var obj = store.get("trafficlayer");
    if (!obj) {
      obj = new defaults.classes.TrafficLayer();
      obj.setMap(map);
      store.add(args, "trafficlayer", obj);
    }
    manageEnd(args, obj);
  };

  /**
   * add a bicycling layer
   **/
  self.bicyclinglayer = function (args) {
    newMap();
    var obj = store.get("bicyclinglayer");
    if (!obj) {
      obj = new defaults.classes.BicyclingLayer();
      obj.setMap(map);
      store.add(args, "bicyclinglayer", obj);
    }
    manageEnd(args, obj);
  };

  /**
   * add a ground overlay
   **/
  self.groundoverlay = function (args) {
    args.opts.bounds = toLatLngBounds(args.opts.bounds);
    if (args.opts.bounds){
      newMap(args.opts.bounds.getCenter());
    }
    var id,
      obj = new defaults.classes.GroundOverlay(args.opts.url, args.opts.bounds, args.opts.opts);
    obj.setMap(map);
    id = store.add(args, "groundoverlay", obj);
    manageEnd(args, obj, id);
  };

  /**
   * set a streetview
   **/
  self.streetviewpanorama = function (args) {
    if (!args.opts.opts) {
      args.opts.opts = {};
    }
    if (args.latLng) {
      args.opts.opts.position = args.latLng;
    } else if (args.opts.opts.position) {
      args.opts.opts.position = toLatLng(args.opts.opts.position);
    }
    if (args.td.divId) {
      args.opts.container = document.getElementById(args.td.divId);
    } else if (args.opts.container) {
      args.opts.container = $(args.opts.container).get(0);
    }
    var id, obj = new defaults.classes.StreetViewPanorama(args.opts.container, args.opts.opts);
    if (obj) {
      map.setStreetView(obj);
    }
    id = store.add(args, "streetviewpanorama", obj);
    manageEnd(args, obj, id);
  };

  self.kmllayer = function (args) {
    var objs = [],
      multiple = "values" in args.td;
    if (!multiple) {
      args.td.values = [{options: args.opts}];
    }
    if (!args.td.values.length) {
      manageEnd(args, false);
      return;
    }
    $.each(args.td.values, function (i, value) {
      var id, obj, options,
        td = tuple(args, value);
      if (!map) {
        newMap();
      }
      options = td.options;
      // compatibility 5.0-
      if (td.options.opts) {
        options = td.options.opts;
        if (td.options.url) {
          options.url = td.options.url;
        }
      }
      // -- end --
      options.map = map;
      if (googleVersionMin("3.10")) {
        obj = new defaults.classes.KmlLayer(options);
      } else {
        obj = new defaults.classes.KmlLayer(options.url, options);
      }
      objs.push(obj);
      id = store.add({td: td}, "kmllayer", obj);
      attachEvents($this, {td: td}, obj, id);
    });
    manageEnd(args, multiple ? objs : objs[0]);
  };

  /**
   * add a fix panel
   **/
  self.panel = function (args) {
    newMap();
    var id, $content,
      x = 0,
      y = 0,
      $div = $(document.createElement("div"));

    $div.css({
      position: "absolute",
      zIndex: 1000,
      visibility: "hidden"
    });

    if (args.opts.content) {
      $content = $(args.opts.content);
      $div.append($content);
      $this.first().prepend($div);

      if (!isUndefined(args.opts.left)) {
        x = args.opts.left;
      } else if (!isUndefined(args.opts.right)) {
        x = $this.width() - $content.width() - args.opts.right;
      } else if (args.opts.center) {
        x = ($this.width() - $content.width()) / 2;
      }

      if (!isUndefined(args.opts.top)) {
        y = args.opts.top;
      } else if (!isUndefined(args.opts.bottom)) {
        y = $this.height() - $content.height() - args.opts.bottom;
      } else if (args.opts.middle) {
        y = ($this.height() - $content.height()) / 2
      }

      $div.css({
        top: y,
        left: x,
        visibility: "visible"
      });
    }

    id = store.add(args, "panel", $div);
    manageEnd(args, $div, id);
    $div = null; // memory leak
  };

  /**
   * add a direction renderer
   **/
  self.directionsrenderer = function (args) {
    args.opts.map = map;
    var id,
      obj = new gm.DirectionsRenderer(args.opts);
    if (args.td.divId) {
      obj.setPanel(document.getElementById(args.td.divId));
    } else if (args.td.container) {
      obj.setPanel($(args.td.container).get(0));
    }
    id = store.add(args, "directionsrenderer", obj);
    manageEnd(args, obj, id);
  };

  /**
   * returns latLng of the user
   **/
  self.getgeoloc = function (args) {
    manageEnd(args, args.latLng);
  };

  /**
   * add a style
   **/
  self.styledmaptype = function (args) {
    newMap();
    var obj = new defaults.classes.StyledMapType(args.td.styles, args.opts);
    map.mapTypes.set(args.td.id, obj);
    manageEnd(args, obj);
  };

  /**
   * add an imageMapType
   **/
  self.imagemaptype = function (args) {
    newMap();
    var obj = new defaults.classes.ImageMapType(args.opts);
    map.mapTypes.set(args.td.id, obj);
    manageEnd(args, obj);
  };

  /**
   * autofit a map using its overlays (markers, rectangles ...)
   **/
  self.autofit = function (args) {
    var bounds = new gm.LatLngBounds();
    $.each(store.all(), function (i, obj) {
      if (obj.getPosition) {
        bounds.extend(obj.getPosition());
      } else if (obj.getBounds) {
        bounds.extend(obj.getBounds().getNorthEast());
        bounds.extend(obj.getBounds().getSouthWest());
      } else if (obj.getPaths) {
        obj.getPaths().forEach(function (path) {
          path.forEach(function (latLng) {
            bounds.extend(latLng);
          });
        });
      } else if (obj.getPath) {
        obj.getPath().forEach(function (latLng) {
          bounds.extend(latLng);
        });
      } else if (obj.getCenter) {
        bounds.extend(obj.getCenter());
      } else if (typeof Clusterer === "function" && obj instanceof Clusterer) {
        obj = store.getById(obj.id(), true);
        if (obj) {
          obj.autofit(bounds);
        }
      }
    });

    if (!bounds.isEmpty() && (!map.getBounds() || !map.getBounds().equals(bounds))) {
      if ("maxZoom" in args.td) {
        // fitBouds Callback event => detect zoom level and check maxZoom
        gm.event.addListenerOnce(
          map,
          "bounds_changed",
          function () {
            if (this.getZoom() > args.td.maxZoom) {
              this.setZoom(args.td.maxZoom);
            }
          }
        );
      }
      map.fitBounds(bounds);
    }
    manageEnd(args, true);
  };

  /**
   * remove objects from a map
   **/
  self.clear = function (args) {
    if (isString(args.td)) {
      if (store.clearById(args.td) || store.objClearById(args.td)) {
        manageEnd(args, true);
        return;
      }
      args.td = {name: args.td};
    }
    if (args.td.id) {
      $.each(array(args.td.id), function (i, id) {
        store.clearById(id) || store.objClearById(id);
      });
    } else {
      store.clear(array(args.td.name), args.td.last, args.td.first, args.td.tag);
      store.objClear(array(args.td.name), args.td.last, args.td.first, args.td.tag);
    }
    manageEnd(args, true);
  };

  /**
   * return objects previously created
   **/
  self.get = function (args, direct, full) {
    var name, res,
      td = direct ? args : args.td;
    if (!direct) {
      full = td.full;
    }
    if (isString(td)) {
      res = store.getById(td, false, full) || store.objGetById(td);
      if (res === false) {
        name = td;
        td = {};
      }
    } else {
      name = td.name;
    }
    if (name === "map") {
      res = map;
    }
    if (!res) {
      res = [];
      if (td.id) {
        $.each(array(td.id), function (i, id) {
          res.push(store.getById(id, false, full) || store.objGetById(id));
        });
        if (!isArray(td.id)) {
          res = res[0];
        }
      } else {
        $.each(name ? array(name) : [undef], function (i, aName) {
          var result;
          if (td.first) {
            result = store.get(aName, false, td.tag, full);
            if (result) {
              res.push(result);
            }
          } else if (td.all) {
            $.each(store.all(aName, td.tag, full), function (i, result) {
              res.push(result);
            });
          } else {
            result = store.get(aName, true, td.tag, full);
            if (result) {
              res.push(result);
            }
          }
        });
        if (!td.all && !isArray(name)) {
          res = res[0];
        }
      }
    }
    res = isArray(res) || !td.all ? res : [res];
    if (direct) {
      return res;
    } else {
      manageEnd(args, res);
    }
  };

  /**
   * run a function on each items selected
   **/
  self.exec = function (args) {
    $.each(array(args.td.func), function (i, func) {
      $.each(self.get(args.td, true, args.td.hasOwnProperty("full") ? args.td.full : true), function (j, res) {
        func.call($this, res);
      });
    });
    manageEnd(args, true);
  };

  /**
   * trigger events on the map
   **/
  self.trigger = function (args) {
    if (isString(args.td)) {
      gm.event.trigger(map, args.td);
    } else {
      var options = [map, args.td.eventName];
      if (args.td.var_args) {
        $.each(args.td.var_args, function (i, v) {
          options.push(v);
        });
      }
      gm.event.trigger.apply(gm.event, options);
    }
    callback(args);
    task.ack();
  };
}

$.fn.gmap3 = function () {
  var i,
    list = [],
    empty = true,
    results = [];

  // init library
  initDefaults();

  // store all arguments in a td list
  for (i = 0; i < arguments.length; i++) {
    if (arguments[i]) {
      list.push(arguments[i]);
    }
  }

  // resolve empty call - run init
  if (!list.length) {
    list.push("map");
  }

  // loop on each jQuery object
  $.each(this, function () {
    var $this = $(this),
      gmap3 = $this.data("gmap3");
    empty = false;
    if (!gmap3) {
      gmap3 = new Gmap3($this);
      $this.data("gmap3", gmap3);
    }
    if (list.length === 1 && (list[0] === "get" || isDirectGet(list[0]))) {
      if (list[0] === "get") {
        results.push(gmap3.get("map", true));
      } else {
        results.push(gmap3.get(list[0].get, true, list[0].get.full));
      }
    } else {
      gmap3._plan(list);
    }
  });

  // return for direct call only
  if (results.length) {
    if (results.length === 1) { // 1 css selector
      return results[0];
    }
    return results;
  }

  return this;
};
})(jQuery);
///#source 1 1 /Themes/Default/js/plugins/jquery.mb-waitspinner.js
/// <reference path="../../../Scripts/jquery-1.11.0.js" />
/// <reference path="../../../Scripts/jquery-1.11.0.intellisense.js" />
/*******************************************
	MbWaitSpinner
	A simple spin.js implementation to 
	wondow load event
	(c) Bruno Milgiaretti 2014
********************************************/
;var MbWaitSpinner;

(function () {
	"use strict";
	
	MbWaitSpinner = function (opt) {
		if (!$().spin ) throw (new Error('Spin.js required !!!'));
		var defaults = {
			locked: false,
			overlayColor: "transparent",
			color: "#000",
			callback: null
		};
		var options = {};
		$.extend(options, defaults, opt);
		this.locked = options.locked;
		this.overlayColor = options.windowColor;
		this.spinOptions = options;
		this.callback = options.callback;
	}
	MbWaitSpinner.prototype = {
		show: function () {
			this.$element = $('<div />');
			if (this.locked) {
				this.$element
					.css({
						position: "fixed",
						top: 0,
						bottom: 0,
						left: 0,
						right: 0,
						"background-color": this.overlayColor,
						"z-index": 1000
					});
			} else {
				this.$element
					.css({
						position: "fixed",
						top:"50%",
						left:"50%",
						height:"80px",
						width: "80px",
						margin: "-40px 0 0 -40px"
					});
			}
			this.$element.appendTo("body").spin(this.spinOptions);
		},
		hide: function () {
			this.$element.remove();
		}
	};
	
	$.fn.mb_waitspinner = function(options) {
		return $(this).each(function(index, element) {
			var ws;
			if(index == 0) {
				ws = new MbWaitSpinner(options);
				ws.show();
				$(window).load(function () {
					if ($.isFunction(ws.callback)) {
						if (ws.callback(ws))
							ws.hide();
					}
					else
					{
						ws.hide();
					}
				})
			}
		});
	}
	
}).call(this);
///#source 1 1 /Themes/Default/js/plugins/SmoothAnchors.js
// Copyright (C) 2012 Alex Robinson (http://alextrob.net/)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy 
// of this software and associated documentation files (the "Software"), to deal 
// in the Software without restriction, including without limitation the rights 
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell 
// copies of the Software, and to permit persons to whom the Software is 
// furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in 
// all copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, 
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE 
// SOFTWARE.

(function( $ ) {
	$.fn.SmoothAnchors = function() {

		function scrollBodyTo(destination, hash) {

			// Change the hash first, then do the scrolling. This retains the standard functionality of the back/forward buttons.

			var scrollmem = $(document).scrollTop();
			window.location.hash = hash;
			$(document).scrollTop(scrollmem);
			$("html,body").animate({scrollTop:destination}, 200);
			
		}

		if (typeof $().on == "function") {
			$(document).on('click', 'a[href^="#"]', function() {
				
				var href = $(this).attr("href");
				
				if ($(href).length == 0) {
					
					var nameSelector = "[name=" + href.replace("#", "") + "]";

					if (href == "#") {
						scrollBodyTo(0, href);
					}
					else if ($(nameSelector).length != 0)  {
						scrollBodyTo($(nameSelector).offset().top, href);
					}
					else {
						// fine, we'll just follow the original link. gosh.
						window.location = href;
					}
				}
				else {
					scrollBodyTo($(href).offset().top, href);
				}
				return false;
			});
		}
		else {
			$('a[href^="#"]').click(function() {
				var href = $(this).attr("href");
				
				if ($(href).length == 0) {
					
					var nameSelector = "[name=" + href.replace("#", "") + "]";

					if (href == "#") {
						scrollBodyTo(0, href);
					}
					else if ($(nameSelector).length != 0)  {
						scrollBodyTo($(nameSelector).offset().top, href);
					}
					else {
						// fine, we'll just follow the original link. gosh.
						window.location = href;
					}
				}
				else {
					scrollBodyTo($(href).offset().top, href);
				}
				return false;
			});
		}
	};
})( jQuery );
