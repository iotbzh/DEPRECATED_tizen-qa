(function() {

//var DEBUG=true;

window.ToolsView = Backbone.View.extend({
	initialize:function () {
		this.render();
	},
	render:function () {
		$(this.el).html(this.template());
		return this;
	}
});

})();
