(function() {

  function unexpand($navigation, level) {
    $navigation.find('.navy-navigation-bar[data-navy-navigation-level="' + (level + 1) + '"].navy-hidden').hide();
    $navigation.find('.navy-navigation-bar[data-navy-navigation-level="' + (level + 1) + '"].navy-current').show();
    var $thisBar = $navigation.find('.navy-navigation-bar[data-navy-navigation-level="' + level + '"]');
    $thisBar.find('.navy-section-expanded').removeClass('navy-section-expanded navy-active');
    $thisBar.find('.navy-section.navy-current').addClass('navy-active');
  }

  function expand($navigation, level, idToOpen) {
    unexpand($navigation, level);
    $navigation.find('.navy-navigation-bar[data-navy-navigation-level="' + (level + 1) + '"]').hide();
    $navigation.find('.navy-navigation-bar[data-navy-opened-by="' + idToOpen + '"][data-navy-navigation-level="' + (level + 1) + '"]').show();
    var $thisBar = $navigation.find('.navy-navigation-bar[data-navy-navigation-level="' + level + '"]');
    $thisBar.find('.navy-current').removeClass('navy-active');
  }

  function layout() {
    $('.navy-navigation .navy-navigation-dropdown').each(function() {
      var $dropdown = $(this);
      var $bar = $dropdown.closest('.navy-navigation-bar');
      var $layouted_sections = $bar.find('.navy-layouted-sections');
      var $dropdown_sections = $bar.find('.navy-dropdown-sections');
      $dropdown_sections.find('.navy-section').appendTo($layouted_sections);
      if ( $layouted_sections.find('.navy-section:last').offset().top > $layouted_sections.find('.navy-section:first').offset().top ) {
        var barTop = $bar.offset().top;
        while ( $dropdown.offset().top > barTop ) {
          var $last_section = $layouted_sections.find('.navy-section:not(.navy-current):last')
          $last_section.detach().prependTo($dropdown_sections);
          if ( $last_section.length == 0 ) break;
        }
      }
      if ( $dropdown_sections.find('.navy-section').length > 0 ) {
        $dropdown.css('visibility', 'visible');
      } else {
        $dropdown.css('visibility', 'hidden');
      }
    });
  }

  function sectionExpanderClicked() {
    var $section = $(this).closest('.navy-section');
    var level = Number($section.closest('.navy-navigation-bar').data('navy-navigation-level'));
    var openId = $section.data('navy-opens');
    if ( $section.hasClass('navy-section-expanded') ) {
      unexpand($section.closest('.navy-navigation'), level, openId);
    } else {
      expand($section.closest('.navy-navigation'), level, openId);
      $section.addClass('navy-section-expanded navy-active');
    }
    return false;
  }

  function navigationDropdownClicked() {
    var $dropdownExpander = $(this);
    var $dropdown = $dropdownExpander.closest('.navy-navigation-dropdown');
    if ( $dropdownExpander.hasClass('navy-section-expanded') ) {
      $dropdownExpander.removeClass('navy-section-expanded navy-active');
      $dropdown.find('.navy-dropdown-sections').hide();
    } else {
      $dropdownExpander.addClass('navy-section-expanded navy-active');
      $dropdown.find('.navy-dropdown-sections').show();
    }
  }

  function init() {
    $(function() {
      $('.navy-navigation .navy-section-expander').live('click', sectionExpanderClicked);

      // difficult to handle in selenium, since it now depends on browser width
      $('.navy-navigation .navy-dropdown-expander').live('click', navigationDropdownClicked);

      $(window).resize(layout);
      
      layout();
    });
  }

  return { init: init, unexpand: unexpand };
})().init();
