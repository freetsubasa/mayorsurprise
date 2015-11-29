#= require jquery
#= require materialize
#= require _kptalks.v2.min
#= require_tree .

$ ->
  is_pc = $('body.pc_index, body.pc_mayor').length > 0

  $('.actionbar').css 'background', ["#4f67a3", "#ee6e73", "#009688"][Math.floor(Math.random() * 3)]

  $('[data-action=sidenav]').sideNav {
    menuWidth: if is_pc then 500 else 300
  }
  new Swiper '.swiper-container', {
    nextButton: '.swiper-button-next'
    prevButton: '.swiper-button-prev'
    #pagination: '.swiper-pagination'
    #paginationClickable: true
    preloadImages: true
    loop: true
    centeredSlides: true
    autoplay: 2500
    autoplayDisableOnInteraction: false
  }

  if is_pc
    last_scroll = $(window).scrollTop()
    searchbarHeight = $('.search-container').outerHeight(true)
    $(window).on 'scroll', ->
      scrollTop = $(window).scrollTop()
      scrollTop = Math.min(scrollTop, $(document).height() - $(window).height()) # Safari issue
      movement = scrollTop - last_scroll
      searchbar = $('.search-container')
      searchbarTop = parseInt(searchbar.css('top').replace(/px/, '')) || 0
      if (scrollTop <= 0) # Safari issue
        newTop = -scrollTop
      else
        newTop = Math.max(Math.min(searchbarTop - movement, 0), -searchbarHeight)
      searchbar.css 'top', newTop + 'px'
      searchbar.css('display', if newTop != -searchbarHeight then "inherit" else "none")

      last_scroll = scrollTop
  else
    last_scroll = $(window).scrollTop()
    actionbarHeight = $('.actionbar').outerHeight()
    $(window).on 'scroll', ->
      scrollTop = $(window).scrollTop()
      scrollTop = Math.min(scrollTop, $(document).height() - $(window).height()) # Safari issue
      movement = scrollTop - last_scroll
      actionbar = $('.actionbar')
      actionbarTop = parseInt(actionbar.css('top').replace(/px/, '')) || 0
      if (scrollTop <= 0) # Safari issue
        newTop = -scrollTop
      else
        newTop = Math.max(Math.min(actionbarTop - movement, 0), -actionbarHeight)
      actionbar.css 'top', newTop + 'px'
      actionbar.toggleClass('z-depth-0-5', newTop != -actionbarHeight)

      last_scroll = scrollTop

  if $('body.pc_index').length > 0
    $.kptalks {
      image: [
        'images/kp.png'
      ]
      width: 350
      height: 500
      effect: 'jump'
      popup_effect: 'zoom'
      enter_distance: -30
      default_text: '<br><br><span style="font-size: 24px;">加速吧！新竹！</span>'
    }

  if is_pc
    $('.main-container .row').masonry {
      itemSelector: '.col'
    }
    $('.main-container .col img').on 'load', ->
      $('.main-container .row').masonry('layout')

  $('.main-container a[data-title]').on 'click', ->
    that = $(this)
    $('.news-modal h4').html(that.attr('data-title'))
    $('.news-modal p').html(that.attr('data-content'))
    $('.news-modal').openModal()
    false

  $('i.fa.fa-search').on 'click', ->
    if $('#search').val() == ''
      return
    window.open('https://cse.google.com/cse?cx=018066583580703833098%3Aq-9djauyj98&q=' + $('#search').val())
