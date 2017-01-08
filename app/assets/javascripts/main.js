$(document).on('turbolinks:load', function() {
  $fill_star = $('input[name="review[rate]"]');
  $('.starrr').starrr();

  function rate() {
    $fill_star.hide();
    $('#stars').on('starrr:change', function(e, value) {
      e.preventDefault();
      $fill_star.val(value);
    });
  }
  rate();
  $(function() {
    $('.review-item').slice(0, 4).show();
    $('#loadMore').on('click', function(e) {
      e.preventDefault();
      $('.review-item:hidden').slice(0, 4).slideDown();
      if ($('.review-item:hidden').length == 0) {
        $('#loadMore').fadeOut('slow');
      }
      $('html,body').animate({
        scrollTop: $(this).offset().top
      }, 1500);
    });
  });
  $('a[href="#top"]').click(function() {
    $('body,html').animate({
      scrollTop: 0
    }, 600);
    return false;
  });
  $(window).scroll(function() {
    if ($(this).scrollTop() > 50) {
      $('.totop').fadeIn();
      $('.totop a').fadeIn();
    } else {
      $('.totop').fadeOut();
      $('.totop a').fadeOut();
    }
  });

  function isEmpty(el) {
    return !$.trim(el.html())
  }
  if (isEmpty($('.no-rating'))) {
    $('.no-rating').hide();
  }
  $('[data-toggle="tooltip"]').tooltip();

  $('body').on('click', '.btn-like', function(e) {
    e.preventDefault();
    $btn = $(this);
    $url = $(this).attr('href');
    $book_id = $url.split('=')[1];
    $del_url = 'likes/' + $book_id;
    $.ajax({
      dataType: 'html',
      url: $url,
      method: 'post',
      success: function() {
        $btn.removeClass('fa fa-thumbs-up btn-like').addClass('fa fa-thumbs-o-up btn-un-like');
        $btn.attr('href', $del_url);
      }
    })
    return false;
  });

  $('body').on('click', '.btn-un-like', function(e) {
    e.preventDefault();
    $btn = $(this);
    $url = $(this).attr('href');
    $book_id = $url.slice(-1);
    $add_url = 'likes?id=' + $book_id;
    $.ajax({
      dataType: 'html',
      url: $url,
      method: 'delete',
      success: function() {
        $btn.removeClass('fa fa-thumbs-o-up btn-un-like').addClass('fa fa-thumbs-up btn-like');
        $btn.attr('href', $add_url);
      }
    })
    return false;
  });

  $('#sidebar').affix({
    offset: {
      top: 235
    }
  });

  var $body   = $(document.body);
  var navHeight = $('.navbar').outerHeight(true) + 10;

  $body.scrollspy({
    target: '#leftCol',
    offset: navHeight
  });

  $('a[href*=\\#]:not([href=\\#])').click(function() {
    if (location.pathname.replace(/^\//,'') == this.pathname.replace(/^\//,'') &&
      location.hostname == this.hostname) {
      var target = $(this.hash);
      target = target.length ? target : $('[name=' + this.hash.slice(1) +']');
      if (target.length) {
        $('html,body').animate({
          scrollTop: target.offset().top - 50
        }, 1000);
        return false;
      }
    }
  });
});
