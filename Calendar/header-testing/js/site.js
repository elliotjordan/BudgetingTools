/*!
 * Site Specific IU Search Init
 */
  $( window ).ready(function() {
    var imgHeight = $('#banner').height();
var fromTop = imgHeight + 56;
console.log(imgHeight);

$(".legacy-banner .section-nav").css({ top: "-"+fromTop+'px' });
});
(function (window, document, $, undefined) {

    $(document).ready(function() {

        var IUSearch = window.IUSearch || {};

        var searchOptions = {
            CX: {
                site: '012691600539475629177:xfioloz7rhs', // Replace this with site CX value
                all: '016278320858612601979:ddl1l9og1w8' // Replace this with campus CX value
            },
            wrapClass: 'row pad',
            searchBoxIDs: ['search']
        }

        /* Initialize global search */
        IUSearch.init && IUSearch.init( searchOptions );
    });

})(window, window.document, jQuery);

(function (window, document, $, undefined) {
    $(window).ready(function() {
        
        Foundation.OffCanvas.defaults.transitionTime = 500;
        Foundation.OffCanvas.defaults.forceTop = false;
        Foundation.OffCanvas.defaults.positiong = 'right';

        Foundation.Accordion.defaults.multiExpand = true;
        Foundation.Accordion.defaults.allowAllClosed = true;

        $(document).foundation();
        
        var IU = window.IU || {};
        
        /* Delete modules if necessary (prevents them from auto-initializing) */
        // delete IU.uiModules['accordion'];
        delete IU.addHelper['mainHeight'];
        /*
         * Initialize global IU & its modules
         * Custom settings can be passsed here
         */
        IU.init && IU.init({debug: true});
    });
})(window, window.document, jQuery);

// Loads menu accessability scripts per menu
$(window).on('load', function(){
	if ( $( "#nav-global ul" ).length ) {
 
    var menubar = new Menubar(document.querySelector('#nav-global ul'));
  	menubar.init();
 
}
    
});

$(window).on('load', function(){
	if ( $( "#nav-main ul" ).length ) {
 
    var menubar = new Menubar(document.querySelector('#nav-main ul'));
  	menubar.init();
 
}
    
});