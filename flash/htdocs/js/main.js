(function() {

// debug main 
// var DEBUG=true;

// global debug
window.DEBUG=true;

var AppRouter=Backbone.Router.extend({
	routes: {
		""								:	"home",
		"home"						:	"home",
		"tools"						:	"tools",
		"help"						:	"help",
		"about"						:	"about"
	},

	initialize: function() {
		this.headerView=new HeaderView();
		$('.header').html(this.headerView.el);

		this._curview=null;
	},

	_switchToView: function(name,klass) {
		DEBUG && console.log("Switching to view "+name);

		var vname=name+"View"; // HomeView, DAQServerView ...

		if (!(vname in this)) {
			this[vname]=new klass();
		}

		var view=this[vname]; // instance

		// save previous view
		var previous=this._curview;

		// replace content div by new view element
		this._curview=view;
		$('#content').html(view.el);

		// switch to correct menu item
		this.headerView.selectMenuItem(name.toLowerCase()+"-menu");

		// tell new view that it's now active
		if (typeof view.onShow == 'function') {
			view.onShow();
		}

		// tell previous view that it disappears
		if (previous && (typeof previous.onHide == 'function')) {
			previous.onHide();
		}
	},
				
	home: function() {
		this._switchToView("home",HomeView);
	},
	tools: function() {
		this._switchToView("tools",ToolsView);
	},
	help: function() {
		this._switchToView("help",HelpView);
	},
	about: function() {
		this._switchToView("about",AboutView);
	}
});

utils.loadTemplate(
	{
		'HeaderView'					: 'js/header/header.html',
		'HomeView'						: 'js/home/home.html',
		'ToolsView'						: 'js/tools/tools.html',
		'HelpView'						: 'js/help/help.html',
		'AboutView'						: 'js/about/about.html',
	},
	function() {
		var app=new AppRouter();
		Backbone.history.start();
	}
);

})();
