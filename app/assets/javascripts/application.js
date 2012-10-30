//= require jquery_ujs
//= require jquery_ui
//= require bootstrap
//= require_tree ./plugins/

!function ($, w) {

  "use strict";

  var app = w.Message = {}

  var Message = function(options) {
    var _this = this
    var selected_box = 'inbox'
    
    _this.options = options
    _this.counters = {
      unread: $('.unread-messages-counter'),
      sent: $('.sent-messages-counter')
    }
    _this.container = {
      inbox: $('#inbox_messages'),
      sent: $('#sent_messages')
    }

    $(document).on('ajax:complete', function() {
      $('.message-delete').on('ajax:success', function(data) {
        _this._remove(_this._getMessageById($(this).data('id')))
      })
      
      $('.message-read').on('ajax:success', function(data) {
        _this._read(_this._getMessageById($(this).data('id')))
      })

      $('.message-mark-all-read').on('ajax:success', function() {})
      
      $('.message-sent').on('ajax:success', function() {})

      _this.update()
    })
            
    $('.message-mark-selected-read').on('click', function() {
      var url = '/messages/mark_selected_read?' + $('input:checkbox').serialize()
      $.get(url, {}, function() { _this.update() })
    })
    
    $('.message-delete-selected').on('click', function() {
      var checked_messages = $('input:checkbox').serialize()
      if ( checked_messages ) {
        if ( confirm("Are you sure to delete selected messages?") == true) {
          var url = '/messages/delete_selected?' + checked_messages + '&box=' + selected_box
          $.get(url, {}, function() { _this.update() })
        }
      }
    })
          
    $('li a[data-toggle="tab"]').click( function() {
      if ($(this).text() == 'Sent') {
        selected_box = 'sent'
        $('.in-box').hide()
      } else {
        selected_box = 'inbox'
        $('.in-box').show()
      }
    });
    
    if (_this.options.checker)
      _this._checker()
  }

  Message.prototype.update = function() {
    var _this = this
    $.getJSON(_this.options.url.counters, function(data) {
      if (data)
        _this._setCounters(data)
    })
  }

  Message.prototype._setCounters = function(counters) {
    var _this = this
    ,   currentCounters = {
          unread: parseInt(this.counters.unread.first().text(), 10),
          sent: parseInt(this.counters.sent.first().text(), 10)
        }

    $.each([{box: 'inbox', counter: 'unread'}, {box: 'sent', counter: 'sent'}], function() {
      var type = this
      if (currentCounters[type.counter] != counters[type.counter]) {
        if (_this.container[type.box].length)
          _this._updateBox(counters[type.counter], type.box, type.counter)
        else
          _this.counters[type.counter].html(counters[type.counter])
      }
    })
  }

  Message.prototype._updateBox = function(count, box, counter) {
    var _this = this
    var page_inbox = $('#page_inbox').val();
    var page_sent = $('#page_sent').val();

    $.get(_this.options.url.index, {box: box, page_inbox: page_inbox, page_sent: page_sent}, function(data) {
      _this.container[box].html(data)
      _this.counters[counter].html(count)
    });
  }

  Message.prototype._getMessageById = function(id) {
    return $('#message_'+id)
  }

  Message.prototype._read = function(message) {
    message.removeClass('info')
  }

  Message.prototype._remove = function(message) {
    message.remove()
  }

  Message.prototype._checker = function() {
    var _this = this
    return;

    setInterval(function() {
      _this.update()
    }, 5000)
  }
  
  app.init = function(options) {
    app.messages = new Message(options.messages)
  }
  
}(window.jQuery, window)

