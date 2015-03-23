(function() {

//var DEBUG=true;

window.HomeView = Backbone.View.extend({
	initialize:function () {
		this.render();
	},
	render:function () {
		$(this.el).html(this.template());
		return this;
	},
	onShow: function() {
      this.delegateEvents();
      this.refresh();

      if (!this.rbtimer) {
         var self=this;

         this.rbtimer=setInterval(function() {
            var pct=0;
            if (self.refresh_interval) {
               pct=100*(utils.now()-self.tsrefresh)/self.refresh_interval;
            }
            $('.refreshbar').width(pct.toFixed(0)+"%");
         },333);
      }
   },
	onHide: function() {
      this.stopRefresh();

      // stop progress bar anim
      if (this.rbtimer) clearInterval(this.rbtimer);
      this.rbtimer=null;
   },

   //-------------- events --------------
   events: {
      'click .btnrefresh': function(ev) {
         this.stopRefresh(); // abort autorefresh 
         this.refresh(); // make refresh & restart autorefresh
      },
      'click .setrefresh': function(ev) {
         ev.preventDefault();

         // retrieve value in link
         var value=$(ev.currentTarget).attr("value");

         $(ev.currentTarget).parent().parent().children().removeClass("active");
         $(ev.currentTarget).parent().addClass("active");

         this.setRefresh(value);
      }
   },

   refresh: function() {
      this.tsrefresh=utils.now();

      var self=this;
      function _dorefresh(what,timeout) {
         setTimeout(function() { self.pollState(what); },timeout);
      }

      _dorefresh("wwwserver",50);

      if ((!this.timer) && this.refresh_interval) {
         this.timer=setInterval(function() {
            self.refresh();
         },this.refresh_interval);
      }
   },

   stopRefresh: function() {
      if (this.timer) clearInterval(this.timer);
      this.timer=null;
   },

   setRefresh: function(val) {
      this.stopRefresh();

      var nval=parseFloat(val);
      if ((val == "disabled") || (!isFinite(nval))) {
         this.refresh_interval=0;
      }
      else {
         this.refresh_interval=Math.round(nval*1000); // ms
      }

      if (this.refresh_interval) // not disabled
         this.refresh();
   },

	pollState:function(what) {
      var self=this;

      // update button state
      this.setState(what+"_state",{
         state:"query",
         message:"Querying server state...Please wait."
      });

      // add a small timeout to show that we're querying...
      setTimeout(function() {
         // JSON request to get get state
         var jqxhr=$.getJSON("netboot/state",function(data) {
            DEBUG && console.log("Daemon "+what+" state: ",data);

				// build list of targets
				var table=[];
				
				table.push("<table class='table table-striped table-bordered'>");
				table.push("<tr><th>Name</th><th>IP</th><th>Product</th><th>State</th></tr>");
				_.values(data).forEach(function(dev) {
					table.push("<tr>");
					table.push("<td>"+dev.name+"</td>");
					table.push("<td>"+dev.ip+"</td>");
					table.push("<td>"+dev.product+"</td>");
					table.push("<td>"+dev.state+"</td>");
					table.push("</tr>");
				});
				table.push("</table>");
				table=table.join("");
					
            self.setState(what+"_state",{
					state: "running",
					message: table
				});
         });
         jqxhr.error(function(err) {
            if (what == "wwwserver") {
               self.setState(what+"_state",{
                  state:"stopped",
                  message:"Unable to connect to administration server"
               });
            }
            else {
               self.setState(what+"_state",{
                  state:"unknown",
                  message:"Unable to get server state"
               });
            }
         });
      },500);
   },
	
	setState: function(btnid,obj) {
      var btn=$('#'+btnid);

      // first remove all classes
      btn.removeClass("label-success label-warning label-important label-info label-inverse");

		if (typeof obj!='object') {
         obj={
            state: obj,
            message: ""
         };
      }

      switch(obj.state) {
         case 'query':
            // let button gray
            btn.html("Querying");
            break;
         case 'running':
            btn.html("Running").addClass("label-success");
            break;
         case 'paused':
            btn.html("Paused").addClass("label-info");
            break;
         case 'warning':
            btn.html("Warning").addClass("label-warning");
            break;
         case 'stopped':
            btn.html("Stopped").addClass("label-important");
            break;
         case 'unknown':
         default:
            btn.html("Unknown").addClass("label-inverse");
            break;
      }

      $('#'+btnid+"_caption").html(obj.message);
   }
});

})();
