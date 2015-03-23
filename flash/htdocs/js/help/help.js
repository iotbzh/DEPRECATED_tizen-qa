(function() {

//var DEBUG=true;

window.HelpView = Backbone.View.extend({
	initialize:function () {
		this.render();
	},
	render:function () {
		$(this.el).html(this.template());
		return this;
	}
});

})();

